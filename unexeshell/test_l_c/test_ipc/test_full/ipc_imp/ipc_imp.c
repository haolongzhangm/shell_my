#include "ipc_imp.h"

#include <stdio.h>
#include <stdlib.h>
#include <sys/prctl.h>
#include <sys/wait.h>
#include <unistd.h>

//! default mmap size: 10MB, override by ENV: IPC_MAP_SIZE
static struct ServerConfig {
  pid_t server_id;
  remote_call_cb cb;
  int fd_s[2];
  int fd_c[2];
  fd_set select_s;
  fd_set select_c;
  void *shm_ptr;
  size_t shm_size;
} server_config = {
    .server_id = 0,
    .cb = 0,
    .shm_ptr = 0,
    // default config to 10MB
    .shm_size = 10 * 1024 * 1024,
};

//! internal recycle server when IPC_ASSERT happen
static void recycle_server() {
  static struct timeval tv = {1, 0};
  struct MsgBody msg;
  msg.type = IPC_SERVER_EXIT;
  if (server_config.server_id > 0) {
    send_msg(&msg, &tv);
  }
}

#define ipc_unlikely(v) __builtin_expect((v), 0)
#define IPC_ASSERT(expr, msg)                                                  \
  do {                                                                         \
    if (ipc_unlikely(!(expr))) {                                               \
      printf("ipc fatal error: assert failed: %s with msg: %s\n", #expr, msg); \
      recycle_server();                                                        \
      __builtin_trap();                                                        \
    }                                                                          \
  } while (0)

static void handle_remote_call(struct MsgBody *msg) {
  printf("into %s: %d\n", __func__, __LINE__);
  IPC_ASSERT(server_config.cb, "handle_remote_call failed: can not find valid "
                               "remote_call_cb, please call "
                               "register_remote_call_cb firstly!!");
  server_config.cb(msg);
}

void register_remote_call_cb(remote_call_cb cb) {
  IPC_ASSERT(!server_config.cb, "already register remote_call_cb");
  IPC_ASSERT(cb, "invalid remote_call_cb");
  IPC_ASSERT(server_config.server_id, "register cb need server already up");

  server_config.cb = cb;
  static struct timeval tv = {5, 0};
  struct MsgBody msg;
  msg.type = IPC_CONFIG_REMOTE_HANDLE_API;
  msg.cb = cb;
  send_msg(&msg, &tv);
}

static void *ipc_mmap(void *addr, size_t length, int prot, int flags, int fd,
                      off_t offset) {
  void *ret = mmap(addr, length, prot, flags, fd, offset);
  IPC_ASSERT(ret != MAP_FAILED, "call mmap failed");
  return ret;
}

static int ipc_munmap(void *addr, size_t length) {
  int ret = munmap(addr, length);
  IPC_ASSERT(0 == ret, "call munmap failed");
  return ret;
}
//! start server as soon as possible
static __attribute__((constructor)) void create_server() {
  server_config.shm_ptr =
      ipc_mmap(NULL, server_config.shm_size, PROT_READ | PROT_WRITE,
               MAP_SHARED | MAP_ANON, -1, 0);
  IPC_ASSERT(-1 != pipe(server_config.fd_s), "create server pipe failed");
  IPC_ASSERT(-1 != pipe(server_config.fd_c), "create client pipe failed");

  FD_ZERO(&server_config.select_s);
  FD_ZERO(&server_config.select_c);
  //! config server and client
  FD_SET(server_config.fd_s[0], &server_config.select_s);
  FD_SET(server_config.fd_c[0], &server_config.select_c);

  server_config.server_id = fork();

  IPC_ASSERT(server_config.server_id >= 0, "call fork failed");

  if (server_config.server_id > 0) {
    printf("create server success pid is: %d\n", server_config.server_id);
  } else {
    char *server_name = "ipc_server";
    printf("start server with name: %s....\n", server_name);
    prctl(PR_SET_NAME, (unsigned long)server_name, 0, 0, 0);

    while (1) {
      printf("server wait msg now.....\n");
      int res = select(server_config.fd_s[0] + 1, &server_config.select_s, NULL,
                       NULL, NULL);

      IPC_ASSERT(
          res > 0,
          "select issue happened or timeout(but we do not support timeout)");

      struct MsgBody msg;
      size_t r_size = read(server_config.fd_s[0], &msg, sizeof(msg));
      IPC_ASSERT(r_size == sizeof(msg), "broken pipe msg");

      struct MsgBody response;
      response.type = IPC_SERVER_RESPONSE;
      switch (msg.type) {
      case IPC_CALL_REMOTE_API:
        printf("handle remote call\n");
        handle_remote_call(&msg);
        break;
      case IPC_CONFIG_REMOTE_HANDLE_API:
        printf("handle register remote cb\n");
        server_config.cb = msg.cb;
        break;
      default:
        IPC_ASSERT(IPC_SERVER_EXIT == msg.type, "code issue happened!!");
      }

      size_t w_size = write(server_config.fd_c[1], &response, sizeof(response));
      IPC_ASSERT(w_size == sizeof(response), "write pip failed");

      if (IPC_SERVER_EXIT == msg.type) {
        printf("exit now\n");
        exit(0);
      }
    }
  }
}

struct MsgBody send_msg(struct MsgBody *msg, struct timeval *timeout) {
  IPC_ASSERT(server_config.server_id > 0, "server not ready");
  if (IPC_CALL_REMOTE_API == msg->type) {
    IPC_ASSERT(server_config.cb, "can not find valid remote_call_cb, please "
                                 "call register_remote_call_cb firstly!!");
  }

  //! send msg to server
  size_t w_size = write(server_config.fd_s[1], msg, sizeof(struct MsgBody));
  IPC_ASSERT(w_size == sizeof(struct MsgBody), "write pipe failed");

  //! now wait server response
  struct MsgBody response;
  printf("wait server response\n");

  int res = select(server_config.fd_c[0] + 1, &server_config.select_c, NULL,
                   NULL, timeout);
  if (0 == res) {
    printf("wait server timeout\n");
  }
  IPC_ASSERT(res > 0, "select issue happened or timeout");

  size_t r_size = read(server_config.fd_c[0], &response, sizeof(response));
  IPC_ASSERT(sizeof(response) == r_size, "broken pipe msg");
  IPC_ASSERT(IPC_SERVER_RESPONSE == response.type,
             "error server response type");

  return response;
}

bool is_server() { return !server_config.server_id; }

void join_server() {
  int ret;
  waitpid(server_config.server_id, &ret, 0);
  IPC_ASSERT(ret == 0, "child process exit !zero");
}

void *base_get_shm_ptr() { return server_config.shm_ptr; }

size_t base_get_shm_size() { return server_config.shm_size; }

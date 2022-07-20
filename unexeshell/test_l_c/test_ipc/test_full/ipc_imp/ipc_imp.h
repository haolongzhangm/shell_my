#pragma once

#include <stdbool.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <sys/types.h>

//! server call api ret
enum MsgType {
  IPC_SERVER_RESPONSE = 1,
  IPC_CALL_REMOTE_API = 2,
  IPC_SERVER_EXIT = 3,
  IPC_CONFIG_REMOTE_HANDLE_API = 4,
};

struct MsgBody {
  enum MsgType type;
  //! remote call handle callback
  void *cb;
  //! remote call function emum, define by user
  size_t remote_func_id;
  //! mmap region ptr
  void *shm_ptr;
};

#ifdef __cplusplus
extern "C" {
#endif

//! block wait server return response msg
struct MsgBody send_msg(struct MsgBody *msg, struct timeval *timeout);

//! wait server exit
void join_server();

typedef void (*remote_call_cb)(struct MsgBody *msg);

//! register remote call
void register_remote_call_cb(remote_call_cb cb);

//! is server or not
bool is_server();

//! get shm ptr
void *base_get_shm_ptr();

// get shm size
size_t base_get_shm_size();

#ifdef __cplusplus
}
#endif

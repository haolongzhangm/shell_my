#include <cstdio>
#include <string.h>
#include <string>

#include "api.h"
#include "ipc_helper.h"

using namespace ipc;

static void api_remote_call_cb(struct MsgBody *msg) {
  printf("into %s: %d remote_func_id: %zu\n", __func__, __LINE__,
         msg->remote_func_id);
  switch (static_cast<RemoteFuncId>(msg->remote_func_id)) {
  case RemoteFuncId::TEST_SUM: {
    int *shm_ptr = static_cast<int *>(msg->shm_ptr);
    size_t size = *shm_ptr;
    int ret = test_sum(shm_ptr + 1, shm_ptr + 1 + size, size);
    *shm_ptr = ret;
  }; break;
  default:
    printf("code issue happned!\n");
    __builtin_trap();
  }
};

IpcHelper::IpcHelper() {
  if (!is_server()) {
    shm_ptr = base_get_shm_ptr();
    shm_size = base_get_shm_size();
    register_remote_call_cb(&api_remote_call_cb);
  } else {
    printf("err: code issue happened can not use for client\n");
    __builtin_trap();
  }
};

IpcHelper::~IpcHelper() {
  struct MsgBody msg;
  msg.type = IPC_SERVER_EXIT;
  send_ipc_msg(&msg);
  join_server();
};

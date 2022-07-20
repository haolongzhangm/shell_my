#include <cstdio>
#include <string.h>
#include <string>

#include "api.h"
#include "ipc_helper.h"

int test_sum(int *a, int *b, size_t size) {
  int ret = 0;

  if (is_server()) {
    do {
      ret = ret + a[size - 1] + b[size - 1];
    } while (size-- > 1);
  } else {
    int *shm_ptr = static_cast<int *>(IPC_INSTACE().get_shm_ptr());
    size_t shm_size = IPC_INSTACE().get_shm_size();
    if (shm_size < (size * 2 + 1) * sizeof(int)) {
      printf("shm_size not enough to run this api\n");
      __builtin_trap();
    }
    *shm_ptr = size;
    memcpy(shm_ptr + 1, a, size * sizeof(int));
    memcpy(shm_ptr + 1 + size, b, size * sizeof(int));
    struct MsgBody msg;
    msg.type = IPC_CALL_REMOTE_API;
    msg.shm_ptr = static_cast<void *>(shm_ptr);
    msg.remote_func_id = static_cast<size_t>(ipc::RemoteFuncId::TEST_SUM);
    IPC_INSTACE().send_ipc_msg(&msg);
    ret = *shm_ptr;
  }

  return ret;
}

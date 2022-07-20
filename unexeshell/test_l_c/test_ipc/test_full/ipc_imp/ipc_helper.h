#pragma once

#include <cstdio>
#include <string.h>
#include <string>

#include "ipc_imp.h"

#define IPC_INSTACE() ipc::IpcHelper::Instance()
namespace ipc {

struct NonCopyable {
  NonCopyable() = default;
  NonCopyable(const NonCopyable &) = delete;
  NonCopyable &operator=(const NonCopyable &) = delete;
};

template <class T> class Singleton : public NonCopyable {
public:
  Singleton() {}
  static T &Instance() {
    static T _;
    return _;
  }
};

class IpcHelper : public Singleton<IpcHelper> {
public:
  IpcHelper();

  ~IpcHelper();

  //! send msg with default timeout
  struct MsgBody send_ipc_msg(struct MsgBody *msg) {
    return send_msg(msg, &tv);
  }

  //! get shm ptr
  void *get_shm_ptr() { return shm_ptr; }

  // get shm size
  size_t get_shm_size() { return shm_size; }

private:
  //! 10 minutes
  struct timeval tv = {600, 0};
  void *shm_ptr = nullptr;
  size_t shm_size = 0;
};

enum class RemoteFuncId : size_t {
  TEST_SUM = 1,
};

} // namespace ipc

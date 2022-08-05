#include <chrono>
#include <iostream>
#include <signal.h>
#include <string.h>
#include <string>
#include <sys/prctl.h>
#include <thread>
#include <unordered_map>

namespace {
void thread_exit_handler(int sig) {
  printf("this signal is %d \n", sig);
  pthread_exit(0);
}
}; // namespace

class ThreadHelper {
public:
  void sleep_for(const std::string &tname, int num) {
    struct sigaction actions;
    memset(&actions, 0, sizeof(actions));
    sigemptyset(&actions.sa_mask);
    actions.sa_flags = 0;
    actions.sa_handler = thread_exit_handler;
    sigaction(SIGUSR1, &actions, NULL);

    std::chrono::milliseconds timespan(num);
    prctl(PR_SET_NAME, tname.c_str(), 0, 0, 0);
    std::this_thread::sleep_for(timespan);
  }

  void start(const std::string &tname) {
    std::thread thrd = std::thread(&ThreadHelper::sleep_for, this, tname, 3600);
    tm[tname] = thrd.native_handle();
    thrd.detach();
    std::cout << "Thread " << tname << " created:" << std::endl;
  }

  void stop(const std::string &tname) {
    thread_map::const_iterator it = tm.find(tname);
    if (it != tm.end()) {
      // pthread_cancel(it->second); pthread_cancel not imp at android side
      pthread_kill(it->second, SIGUSR1);
      tm.erase(tname);
      std::cout << "Thread " << tname << " killed:" << std::endl;
    }
  }

private:
  typedef std::unordered_map<std::string, pthread_t> thread_map;
  thread_map tm;
};

int main() {
  ThreadHelper t;
  std::string keyword("test_thread");
  std::string tname1 = keyword + "1";
  std::string tname2 = keyword + "2";
  std::string tname3 = keyword + "3";

  t.start(tname1);
  t.stop(tname1);

  t.start(tname2);
  t.stop(tname2);

  t.start(tname3);
  t.stop(tname3);

  getchar();

  return 0;
}

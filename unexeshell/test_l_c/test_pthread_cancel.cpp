#include <pthread.h>
#include <signal.h>
#include <unistd.h>

#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <cstring>

namespace {

void alloc_memory() {
    //! alloc 80MB memory to test memory leak
    int size = 4 * 1024 * 1024 * 20;
    char *p = (char *)malloc(size);
    for (int i = 0; i < size; i++) {
        p[i] = i % 256;
    }
    printf("alloc_memory: %c\n", p[0]);
}
//! simulate block function, eg, read, write, sleep, opencl-clfinish etc
void *simu_block_func(void *arg) {
    //! return nullptr use to test api normal return
    //! return nullptr;
    alloc_memory();
    //! sleep 100ms, then print
    while (1) {
        usleep(100 * 1000);
        printf("simu_block_func\n");
    }
}

void threadSignalHandler(int signo) {
    printf("threadSignalHandler\n");
    pthread_exit(NULL);
}
void register_handler() {
    printf("signal_handler\n");
    struct sigaction actions;
    memset(&actions, 0, sizeof(actions));
    sigemptyset(&actions.sa_mask);
    actions.sa_flags = 0;
    actions.sa_handler = threadSignalHandler;
    sigaction(SIGUSR2, &actions, NULL);
}

}  // namespace
int main() {
    //! register signal handler
    register_handler();
    pthread_t thread;
    pthread_create(&thread, NULL, simu_block_func, NULL);

    //! loop check thread status, timeout is 5s, then kill it
    int timeout = 5000;
    //! sleep step value ms, FIXME: too short will cause CPU high, too long will
    //! cause delay
    int sleep_step = 100;
    while (timeout > 0) {
        //! check thread is alive
        if (pthread_kill(thread, 0) == ESRCH) {
            printf("thread is dead\n");
            break;
        }
        printf("thread is alive\n");
        usleep(sleep_step * 1000);
        timeout -= sleep_step;
    }
    printf("main getchar to wait user check memory 0\n");
    getchar();
    //! if timeout, kill thread
    if (timeout <= 0) {
        printf("timeout, force kill thread\n");
        pthread_kill(thread, SIGUSR2);
    }
    pthread_join(thread, NULL);

    //! if you see this log, means logic is OK
    printf("main getchar to wait user check memory 1\n");
    getchar();
    return 0;
}

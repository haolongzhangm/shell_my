#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#include "call.h"

class TestA {
   public:
    TestA() { printf("init TestA\n"); }
    ~TestA() { printf("close TestA\n"); }
    void pp() { printf("jjjjjjjjjjjj\n"); }
};

TestA a;

static pthread_once_t init_guard = PTHREAD_ONCE_INIT;

void atexit_func() { printf("%s:  %d\n", __func__, __LINE__); }
void cpuinfo_arm_linux_init() { printf("%s:  %d\n", __func__, __LINE__); }
void call_function() {
    printf("%s:  %d\n", __func__, __LINE__);
    pthread_once(&init_guard, &cpuinfo_arm_linux_init);
    a.pp();

    atexit(atexit_func);
}

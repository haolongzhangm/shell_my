#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>

#define test_alloc_size 1024 * 1024 //1MB
static bool goon = false;

void signal_handle(int signal_number) {
	printf("%s: signal num: %d\n", __func__, signal_number);

  if (signal_number == SIGUSR1) {
    if (goon)
      goon = false;
    else
      goon = true;

  } else {
    printf("do not support signal, ignore\n");
  }

  printf("goon status: %d, my pid: %d\n", goon, getpid());
}

void cgroup_cpu_usage_test() {
  for (;;) {
    if (goon) {
      printf("Now go calulate.....\n");
      float a = 1.999999;
      float b = 0.999999;

      float c = a * b;
    } else {
      usleep(1000 * 1000);
      printf("waiting signal to begin calulate my pid: %d\n", getpid());
    }
  }
}

void cgroup_memory_test() {
  for (;;) {
    if (goon) {
      printf("Now go alloc mem.....\n");
      char *ptr;
      static unsigned long size = 0;

      if ((ptr = (char *)malloc(test_alloc_size)) != NULL) {
        size += test_alloc_size;
        //triger real malloc by memset
        memset(ptr, 0 , test_alloc_size);
        printf("malloc success: %lu MB\n", size / 1024 / 1024);
      } else {
        printf("malloc failed\n");
      }
    } else {
      usleep(1000 * 1000);
      printf("waiting signal to begin alloc mem my pid: %d\n", getpid());
    }
  }
}
int main(int argc, char ** argv) {
  if (argc != 2) {
    printf("need a test num\n");

    return 0;
  }

  int run = atoi(argv[1]);
  printf("int signal: %d\n", SIGUSR1);
  signal(SIGUSR1, signal_handle);

  if (1 == run) {
    cgroup_cpu_usage_test();
  } else if (2 == run) {
    cgroup_memory_test();
  } else {
    printf("do not support args\n");
    printf("cgroup_userspace_test 1: test cpu usage\n");
    printf("cgroup_userspace_test 2: test mem usage\n");
  }

  return 0;
}

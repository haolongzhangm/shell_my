#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <sys/types.h>
#include <unistd.h>

int (*m_ashmem_create_region)(const char *name, size_t size);
int main() {
  char c;
  size_t test_size = 1024 * 20;
  char *s, *shm;

  void *handle;
  handle = dlopen("libcutils.so", RTLD_LAZY);
  if (!handle) {
    printf("dlopen failed\n");
    abort();
  }
  m_ashmem_create_region = (int (*)(const char *name, size_t size))dlsym(
      handle, "ashmem_create_region");
  if (!m_ashmem_create_region) {
    printf("can not find ashmem_create_region function\n");
    abort();
  }
  int fd = m_ashmem_create_region("test_mem", test_size);
  if (!fd) {
    printf("create shard mem failed\n");
    abort();
  }

  pid_t pid = fork();
  if (pid < 0) {
    printf("call fork failed\n");
    abort();
  }

  if (pid > 0) {
    printf("I am father, child is: %d\n", pid);
    shm = (char *)mmap(NULL, test_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd,
                       0);
    if (shm == MAP_FAILED) {
      printf("mmap failed\n");
      abort();
    }

    s = shm;

    for (c = 'a'; c <= 'z'; c++)
      *s++ = c;

    *s = '?';

    while (*shm != '*') {
      printf("wait for client\n");
      sleep(1);
    }

  } else {
    printf("I am child, sleep 5s for test\n");
    char *child_name = "lite_child";
    prctl(PR_SET_NAME, (unsigned long)child_name, 0, 0, 0);
    size_t s_cnt = 5;
    do {
      sleep(1);
    } while (s_cnt-- > 0);
    shm = (char *)mmap(NULL, test_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd,
                       0);
    if (shm == MAP_FAILED) {
      printf("mmap failed\n");
      abort();
    }

    for (s = shm; *s != '?'; s++) {
      putchar(*s);
    }
    putchar('\n');

    *shm = '*';
  }
}

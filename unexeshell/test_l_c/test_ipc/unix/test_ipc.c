#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <sys/shm.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
  char c;
  int shmid;
  key_t key;
  size_t test_size = 1024 * 200;
  char *shm, *s;

  key = 456789;
  //! check exit or not
  if ((shmid = shmget(key, test_size, IPC_EXCL | 0666)) > 0) {
    printf("find old shm, try remove it\n");
    shmctl(shmid, IPC_RMID, NULL);
  }

  if ((shmid = shmget(key, test_size, IPC_CREAT | 0666)) < 0) {
    perror("shmget");
    exit(1);
  }

  pid_t pid = fork();
  if (pid < 0) {
    printf("call fork failed\n");
    abort();
  }

  if (pid > 0) {
    printf("I am father, child is: %d\n", pid);
    if ((shm = shmat(shmid, NULL, 0)) == (char *)-1) {
      perror("shmat");
      exit(1);
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
    if ((shm = shmat(shmid, NULL, 0)) == (char *)-1) {
      perror("shmat");
      exit(1);
    }

    for (s = shm; *s != '?'; s++) {
      putchar(*s);
    }
    putchar('\n');

    *shm = '*';
  }
  shmctl(shmid, IPC_RMID, NULL);
  shmdt(shm);
}

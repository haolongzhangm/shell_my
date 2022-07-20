#include "api.h"
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#define TEST_SIZE 1024

int naive_sum(int *a, int *b, size_t size) {
  int ret = 0;

  do {
    ret = ret + a[size - 1] + b[size - 1];
  } while (size-- > 1);

  return ret;
}

int main() {
  int *a = (int *)malloc(TEST_SIZE * sizeof(int));
  int *b = (int *)malloc(TEST_SIZE * sizeof(int));

  for (size_t i = 0; i < TEST_SIZE; i++) {
    a[i] = i;
    b[i] = i;
  }

  int ret = test_sum(a, b, TEST_SIZE);
  int naive_ret = naive_sum(a, b, TEST_SIZE);

  free(a);
  free(b);

  if (ret != naive_ret) {
    printf("test error: %d vs %d\n", ret, naive_ret);
    return -1;
  } else {
    printf("test pass ret: %d\n", ret);
  }
}

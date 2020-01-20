#include <stdio.h>
int test_value = 0;

void set_value(int a) {
  printf("%s,: %d set value to %d\n", __func__, __LINE__, a);
  test_value = a;
}

int get_value() {
  printf("%s,: %d get value: %d\n", __func__, __LINE__, test_value);
  return test_value;
}

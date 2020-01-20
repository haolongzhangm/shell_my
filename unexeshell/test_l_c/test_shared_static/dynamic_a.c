#include <stdio.h>

void set_value(int);

void dynamic_a_set_value(int a) {
  printf("%s,: %d set value to %d\n", __func__, __LINE__, a);
  set_value(a);
}

#include <stdio.h>

int get_value();

void dynamic_b_get_value() {
  printf("%s,: %d get value  %d\n", __func__, __LINE__, get_value());
}

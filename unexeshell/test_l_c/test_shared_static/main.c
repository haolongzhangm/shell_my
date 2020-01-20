#include <stdio.h>

void dynamic_a_set_value(int);
int dynamic_b_get_value();

int main() {
  printf("%s,: %d\nn", __func__, __LINE__);

  dynamic_a_set_value(100);
  dynamic_b_get_value();
}

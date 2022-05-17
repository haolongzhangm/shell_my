#include "call.h"
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>

void call_sdk() {
  printf("%s,: %d\nn", __func__, __LINE__);
  call_function();
}

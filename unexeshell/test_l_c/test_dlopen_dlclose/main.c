#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>

#define myassert(expr)                                                         \
  do {                                                                         \
    if (!(expr)) {                                                             \
      fprintf(stderr, "assertion `%s' failed on line %d\n", #expr, __LINE__);  \
      abort();                                                                 \
    }                                                                          \
  } while (0)

typedef void (*func_p)(void);

int main() {
  printf("%s,: %d\nn", __func__, __LINE__);
  for (int i = 0; i < 10; i++) {
    getchar();
    printf("%s,: %d\nn", __func__, __LINE__);
    void *handle = dlopen("./libsdk_so.so", RTLD_LAZY);
    myassert(handle);
    typedef void (*func_p)(void);
    func_p invoke = (func_p)(dlsym(handle, "call_sdk"));
    myassert(invoke);
    invoke();
    dlclose(handle);
  }
}

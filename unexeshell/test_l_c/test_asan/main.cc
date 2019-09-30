#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
 
class t
{
  public:
    t(){
      char * k = (char *)malloc(1024);
      memset(k, 5, 1024);
      k[100] = 0;
    };
    ~t(){};
};

void malloc_leaks_1() {

  printf("%s: %d\n", __func__, __LINE__);

  t *m = new t();
  delete m;
}

void malloc_leaks_2() {

  printf("%s: %d\n", __func__, __LINE__);
  float *p = (float *)malloc(sizeof(float));
  *p = 3.14;

  return;
}

void double_free() {

  printf("%s: %d\n", __func__, __LINE__);
  float *p = (float *)malloc(sizeof(float));
  *p = 3.14;

  free(p);
  free(p);

  return;
}

void use_after_free() {

  printf("%s: %d\n", __func__, __LINE__);
  float *p = (float *)malloc(sizeof(float));
  *p = 3.14;

  free(p);
  *p = 0;

  return;
}


void heap_buffer_overflow() {

  printf("%s: %d\n", __func__, __LINE__);
  float *p = (float *)malloc(sizeof(float));
  p++;
  *p = 3.14;

  free(p);
  return;
}

void stack_buffer_overflow() {

  printf("%s: %d\n", __func__, __LINE__);
  int a[6] = {0};

  //boundary write
  a[6] = 0;

  ////boundary read
  int k = a[6];

  return;
}

void alloc_mismatched() {

  printf("%s: %d\n", __func__, __LINE__);
  float *p = (float *)malloc(sizeof(float));
  *p = 3.14;

  delete p;
}

void use_uninit() {

  printf("%s: %d\n", __func__, __LINE__);
  int a[6];

  a[0] = 1;
}

void stack_overflow() {

  printf("%s: %d\n", __func__, __LINE__);
  int a[5536000] = {0};

  return;
}

int main(int argc, char** argv) {

  if (argc != 2) {
    printf("need a test num\n");

    return 0;
  }

  int run = atoi(argv[1]);

  if (1 == run) {
    //Do not apply to Android ASAN
    malloc_leaks_1();
  } else if (2 == run) {
    //Do not apply to Android ASAN
    malloc_leaks_2();
  } else if (3 == run) {
    use_after_free();
  } else if (4 == run) {
    heap_buffer_overflow();
  } else if (5 == run) {
    stack_buffer_overflow();
  }else if (6 == run) {
    //Do not apply to Android ASAN
    //Do not apply to Android valgrind
    alloc_mismatched();
  } else if (7 == run) {
    use_uninit();
  } else if (8 == run) {
    double_free();
  } else if (9 == run) {
    stack_overflow();
  }

  return 0;
}


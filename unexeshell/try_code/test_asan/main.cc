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
      printf("%s:%d,%p\n", __func__, __LINE__, k);
    };
    ~t(){
      printf("%s:%d\n", __func__, __LINE__);
    };
};
int main(int argc, char** argv) {
  //int* a = new int[10];
  for(int i = 0; i < 2; i++) {
    t *m = new t();
    delete m;
  }

  //int a[6];
  //a[10] = 0;
  //a[6] = 0;
  //if (a[argc])
  //  printf("xx\n");
  return 0;
}

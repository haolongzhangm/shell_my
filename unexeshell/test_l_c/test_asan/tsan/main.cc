#include <pthread.h>
#include <stdio.h>
 
int val;
 
void *func1(void *x) {
  val++;
  return NULL;
}
 
void *func2(void *x) {
  val--;
  return NULL;
}
 
int main() {
  pthread_t t[2];

  pthread_create(&t[0], NULL, func1, NULL);
  pthread_create(&t[1], NULL, func2, NULL);

  pthread_join(t[0], NULL);
  pthread_join(t[1], NULL);
}

#include <stdio.h>

#define test_alloc_size 1024 * 1024 //1MB
void test_malloc();

int main(){

	printf("test mem leak\n");
	do {
		usleep(1000 * 20);
		test_malloc();

	} while(1);
}
void test_malloc(){

	char *ptr;
	static unsigned long size = 0;

	if ((ptr = (char *)malloc(test_alloc_size)) != NULL)
	{
		size += test_alloc_size;
		printf("malloc success: %d MB\n", size / 1024 / 1024);
		memset(ptr, 0 , test_alloc_size);

	}
	else
		printf("malloc failed\n");
}

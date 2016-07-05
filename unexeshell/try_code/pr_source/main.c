#include <stdio.h>
#include <stdlib.h>

int local_publice_val();
void test_malloc_0();
void symbol_transformation();

int a = 7;
int main(){

	local_publice_val();
	test_malloc_0();
	symbol_transformation();
}

int local_publice_val(){

	int *public_a = &a;
	int a = 8;

	printf("----%s:[%d]----\n", __func__, __LINE__);

	printf("local a = %d\n", a);
	printf("publice a = %d\n", *public_a);

}

void test_malloc_0(){

	char *ptr;

	printf("----%s:[%d]----\n", __func__, __LINE__);

	if ((ptr = (char *)malloc(0)) == NULL)
		printf("get a null pointer\n");
	else
		printf("get a valid pointer\n");
}

void symbol_transformation(){

	unsigned int a = 6;
	int b = -20;

	printf("----%s:[%d]----\n", __func__, __LINE__);

	(a + b > 6) ? printf(" > 6\n"): printf(" < 6\n");

}

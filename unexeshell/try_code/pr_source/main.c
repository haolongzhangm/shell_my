#include <stdio.h>
#include <stdlib.h>

int local_publice_val();
void test_malloc_0();
void symbol_transformation();
void test_plusp();
void test_union_struct_size();

int a = 7;
int main(){

	local_publice_val();
	test_malloc_0();
	symbol_transformation();
	test_plusp();
	test_union_struct_size();
}

int local_publice_val(){

	int *public_a = &a;
	int a = 8;

	printf("\n\n\n----%s:[%d]----\n", __func__, __LINE__);

	printf("local a = %d\n", a);
	printf("publice a = %d\n", *public_a);

}

void test_malloc_0(){

	char *ptr;

	printf("\n\n\n----%s:[%d]----\n", __func__, __LINE__);

	if ((ptr = (char *)malloc(0)) == NULL)
		printf("get a null pointer\n");
	else
		printf("get a valid pointer\n");
}

void symbol_transformation(){

	unsigned int a = 6;
	int b = -20;

	printf("\n\n\n----%s:[%d]----\n", __func__, __LINE__);

	(a + b > 6) ? printf(" > 6\n"): printf(" < 6\n");

}

void test_plusp(){

	int a, b, c, d;
	a=10;
	b=a++;
	c=++a;
	d=10*a++;
	printf("\n\n\n----%s:[%d]----\n", __func__, __LINE__);
	printf("b, c, c: %d, %d, %d\n", b, c, d);
}

void test_union_struct_size(){
	typedef union {
		long i;
		int k[5];
		char;
	}DATE;

	struct data {
		int cat;
		DATE cow;
		double dog;
	}too;

	DATE max;

	printf("\n\n\n----%s:[%d]----\n", __func__, __LINE__);
	printf("size stuct data %d\n, size max %d ", sizeof(struct data), sizeof(max));
}

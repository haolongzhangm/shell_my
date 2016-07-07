#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

int local_publice_val();
void test_malloc_0();
void symbol_transformation();
void test_plusp();
void test_union_struct_size();
int address_test();
void test_pipe();
void test_scandir();
void test_string_exchange();

int main(){

	local_publice_val();
	test_malloc_0();
	symbol_transformation();
	test_plusp();
	test_union_struct_size();
	address_test();
//	test_pipe();      //test pipe should  annotation other func
	test_scandir();
	test_string_exchange();
}

int a = 7;
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
		char b;
	}DATE;

	struct data {
		int cat;
		DATE cow;
		double dog;
	}too;

	DATE max;

	printf("\n\n\n----%s:[%d]----\n", __func__, __LINE__);
	printf("size stuct data %lu, size max %lu \n", sizeof(struct data), sizeof(max));
}
//define struct
typedef struct {
	int a;
	int *b;
} fisrt_int_typr, *p_first_int_type;

typedef struct {
	int c;
	int *d;
	fisrt_int_typr e_stuct;
	p_first_int_type p_struct;
} contont_struct, *p_contont_struct;


int address_test()
{
	contont_struct  fly;
	p_contont_struct p_fly;
	fisrt_int_typr tmp;
	p_first_int_type p_tmp;

	int const_b = 2;
	int const_bb = 4;
	int const_d = 6;
	int const_dd = 8;

	printf("\n\n\n----%s:[%d]----\n", __func__, __LINE__);
	//malloc mem
	p_fly = malloc(sizeof(contont_struct));

	p_tmp = malloc(sizeof(fisrt_int_typr));

	//check malloc
	if (p_fly == NULL || p_tmp == NULL)
	{
		printf("malloc mem fail\n");

		return 0;
	} else {
		memset(p_fly, 0 , sizeof(contont_struct));
		memset(p_tmp, 0 , sizeof(fisrt_int_typr));
	}

	//send var
	p_tmp->a = 1;
	p_tmp->b = &const_b;

	tmp.a = 3;
	tmp.b = &const_bb;

	//send var
	p_fly->c = 5;
	p_fly->d = &const_d;
	p_fly->e_stuct = tmp;
	p_fly->p_struct = p_tmp;

	//send var
	fly.c = 7;
	fly.d = &const_dd;
	fly.e_stuct = tmp;
	fly.p_struct = p_tmp;

	//print
	printf("p_fly->c = %d\n", p_fly->c);
	printf("p_fly->d = %d\n", *p_fly->d);
	printf("p_fly->e_stuct.a = %d\n", p_fly->e_stuct.a);
	printf("p_fly->e_stuct.b = %d\n", *p_fly->e_stuct.b);
	printf("p_fly->p_struct->c = %d\n", p_fly->p_struct->a);
	printf("p_fly->p_struct->d = %d\n", *p_fly->p_struct->b);

	//print
	printf("fly.c = %d\n", fly.c);
	printf("fly.d = %d\n", *fly.d);
	printf("fly.e_stuct.a = %d\n", fly.e_stuct.a);
	printf("fly.e_stuct.b = %d\n", *fly.e_stuct.b);
	printf("fly.p_struct->c = %d\n", fly.p_struct->a);
	printf("fly.p_struct->d = %d\n", *fly.p_struct->b);

	//free mem
	free(p_fly);
	free(p_tmp);

	return 0;

}


void test_pipe(){
	int filedes[2];
	char buffer[80];
	printf("\n\n\n----%s:[%d]----\n", __func__, __LINE__);

	pipe(filedes);

	if(fork()>0)
	{
		char s[] = "hello pipe\n";

		sleep(1);
		write(filedes[1], s, sizeof(buffer));
	}
	else
	{
		read(filedes[0], buffer, sizeof(buffer));
		printf("buffer = %s", buffer);
	}
}

#define MAX_NAME_LEN 10
#define MAX_CMD_LEN 40

void test_scandir(){
	int i = 0, j = 0;

	struct dirent **net_dev;
	char *i_face[MAX_NAME_LEN] = {"null"};

	printf("\n\n\n----%s:[%d]----\n", __func__, __LINE__);
	j = scandir("/sys/class/net", &net_dev, 0, alphasort);

	while(j--)
	{
		printf("name %s\n", net_dev[j]->d_name);
		i_face[i++] = net_dev[j]->d_name;
	}

	i = 0;
	while(strcmp(i_face[i], ".."))
	{
		printf("patch interface %s to down/up\n", i_face[i++]);
	}
}

void test_string_exchange(){

	char *src = "hello world";

	int len = strlen(src);

	char *dest = (char *) malloc(len + 1);
	char *d = dest;

	char *s = &src[len - 1];

	while(len-- != 0)
		*d++ = *s--;

	*d = 0;

	printf("\n\n\n----%s:[%d]----\n", __func__, __LINE__);
	printf("%s\n", dest);
}

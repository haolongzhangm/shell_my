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
void test_Josephus_mnk();
void call_do_dup();
void do_dup();

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
//	test_Josephus_mnk(); //open whenm needed test
	call_do_dup();
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
//////////////////////////////////////////////////////////////////////////
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
	free(dest);
}
//////////////////////////////////////////////////////////////
//约瑟夫环:约瑟夫环（约瑟夫问题）是一个数学的应用问题：
//已知n个人（以编号1，2，3...n分别表示）围坐在一张圆桌周围。
//从编号为k的人开始报数，数到m的那个人出列；他的下一个人又从1开始报数，数到m的那个人又出列；
//依此规律重复下去，直到圆桌周围的人全部出列
//定义joseph结构体,用于构建链表
struct joseph{
	int num;
	struct joseph *next;
};
//
//n:总的人数
//s:数到几个数出列
//m:从第几个人第一次开始数数
int n, s, m;

void print_info(struct joseph *head)
{
	struct joseph *p;
	p = head;

	printf("%d people num eg:===\n", n);

	do{
		printf("%d\n", p->num);
		p = p->next;
	}while(p != head);
	printf("\n");
}

void out_put_num(struct joseph *head)
{
	int i,j = 1;
	struct joseph *p1, *p2;

	p1 = p2 = head;

	for(i = 1; i < m; i++)
		p1 = p1->next;

	while(n>0)
	{
		for(i = 1; i < s; i++)
		{
			p2 = p1;
			p1 = p1->next;
		}

		printf("第%d 人出列的是:%d\n", j, p1->num);
		p2->next = p1->next;
		n--;
		j++;
	}
}

struct joseph *create()
{
	int i;

	struct joseph *head;
	struct joseph *p1, *p2;

	printf("input total num of people:\n");

	scanf("%d", &n);
	if(0 == n)
		exit(0);

	for(i = 1; i <= n; i++)
	{
		p1 = (struct joseph *)malloc(sizeof(struct joseph));
		p1->num = i;

		if(1 == i)
			head = p1;
		else
			p2->next = p1;
		p2 = p1;
	}

	p2->next = head;
	print_info(head);
	printf("请输入从第几个人开始报数:\n");
	scanf("%d", &m);

	printf("请输入数到第几个人开始出列:\n");
	scanf("%d", &s);

	return head;
}
void test_Josephus_mnk(){

	struct joseph *head;

	printf("\n\n\n----%s:[%d]----\n", __func__, __LINE__);
	head = create();

	out_put_num(head);

	free(head);
}
//数组a[N]，1至N-1这N-1个数存放在a[N]中，其中某个数重复一次。写一个函数，找出被重复的数字。时间复杂度必须为o（N）函数
void do_dup(int a[], int n){

	int i, tmp1, tmp2;

	for(i = 0; i < n; i++)
	{
		tmp1 += (i + 1);
		tmp2 += a[i];
	}

	printf("重复的数：%d\n", n - (tmp2 - tmp1));
}

void call_do_dup(){

	int a[] = {1, 3, 2, 3};
	printf("\n\n\n----%s:[%d]----\n", __func__, __LINE__);
	do_dup(a, 4);
}

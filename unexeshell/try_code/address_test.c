#include <stdio.h>
#include <stdlib.h>

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


//main 
int main()
{
	contont_struct  fly;
	p_contont_struct p_fly;
	fisrt_int_typr tmp;
	p_first_int_type p_tmp;

	int const_b = 2;
	int const_bb = 4;
	int const_d = 6;
	int const_dd = 8;

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

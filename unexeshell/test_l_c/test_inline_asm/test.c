#include <stdio.h>

void test_base() {
	printf("test %s: %d start\n", __func__, __LINE__);
	size_t a = 0;

	asm volatile(
	    "mov x1, xzr \n"
	    "add x1, x1, #101 \n"
	    "add x1, x1, #5 \n"
	    "mov %0, x1 \n"
	    : "+r"(a)
	    :
	    : "cc", "memory", "x1");

	printf("%s: %d, %zu\n", __func__, __LINE__, a);
	printf("test %s: %d end\n", __func__, __LINE__);
}

void test_bfmmla() {
	printf("test %s: %d start\n", __func__, __LINE__);

	asm volatile("bfmmla v16.4s, v4.8h, v0.8h \n"
		     :
		     :
		     : "cc", "memory", "v0", "v4", "v16");

	printf("test %s: %d end\n", __func__, __LINE__);
}

void test_smmla() {
	printf("test %s: %d start\n", __func__, __LINE__);

	asm volatile("smmla v11.4s, v0.16b, v7.16b \n"
		     :
		     :
		     : "cc", "memory", "v0", "v7", "v11");

	printf("test %s: %d end\n", __func__, __LINE__);
}

void test_ummla() {
	printf("test %s: %d start\n", __func__, __LINE__);

	asm volatile("ummla v11.4s, v0.16b, v7.16b \n"
		     :
		     :
		     : "cc", "memory", "v0", "v7", "v11");

	printf("test %s: %d end\n", __func__, __LINE__);
}

void test_usmmla() {
	printf("test %s: %d start\n", __func__, __LINE__);

	asm volatile("usmmla v11.4s, v0.16b, v7.16b \n"
		     :
		     :
		     : "cc", "memory", "v0", "v7", "v11");

	printf("test %s: %d end\n", __func__, __LINE__);
}

int main(int argc, char *argv[]) {
	test_base();
	test_bfmmla();
	test_smmla();
	test_ummla();
	test_usmmla();
	return 0;
}

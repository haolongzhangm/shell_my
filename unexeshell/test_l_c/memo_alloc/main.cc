#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
 
int main(int argc, char** argv) {
	if (2 != argc) {
		printf("need only one param\n");
		printf("mem xxxx (MB)\n");
    return 0;
	}

	static unsigned int loop = 0;
	unsigned long size_o = atoi(argv[1]) * 1024 * 1024;
	unsigned long size_2 = 0;
	while (1) {
		usleep(1000 * 10);
		printf("loop: %d, malloc: %lu MB\n", loop++, size_o/1024/1024);
		void * p = NULL;
		void * p_2 = NULL;
		bool two_block = false;
    unsigned  long size = size_o;
		if (atoi(argv[1]) > 2000)
		{
			two_block =true;
			size = 2000 * 1024 * 1024;
			size_2 = (atoi(argv[1]) - 2000 )* 1024 * 1024;
		}
		p = malloc(size);
		if (two_block)
			p_2 = malloc(size_2);

		if (!p) {
			printf("malloc failed! too big\n");
      return 0;
		}

		if (two_block && !p_2) {
			printf("malloc failed! too big\n");
      return 0;
		}
		char c = loop;
		printf("memset to %c\n", c);
		memset(p, c, size);
		if (two_block)
			memset(p_2, c, size_2);

		printf("free it\n");
		free(p);
		if (two_block)
			free(p_2);
	}

	return 0;
}

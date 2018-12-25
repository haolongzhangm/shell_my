#include <unistd.h>
#include <sys/types.h>

int main() {
	pid_t pid;

	if ((pid = fork()) == 0) {
		do {
			usleep(1000 * 1000);
			printf("child id: %d\n", getpid());
		} while (1);
	} else {
		do {
			usleep(1000 * 1000);
			printf("parent id: %d\n", getpid());
		} while (1);
	}
}

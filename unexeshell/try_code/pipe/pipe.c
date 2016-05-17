#include <unistd.h>
int main(){
	int filedes[2];
	char buffer[80];

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

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

void __attribute__ ((constructor)) constructor_into(void);
void __attribute__ ((destructor)) destructor_into(void);


void signal_handle(int signal_number) {
	printf("+++%s: %d\n", __func__, __LINE__);
	signal(signal_number, SIG_DFL);
	kill(getpid(), signal_number);
}
void into_lib() {
	printf("+++%s: %d\n", __func__, __LINE__);
}

void constructor_into() {
	printf("+++%s: %d\n", __func__, __LINE__);
	//signal(SIGHUP|SIGSEGV|SIGABRT|SEGV_MAPERR, signal_handle);
	signal(SIGHUP, signal_handle);
	signal(SIGSEGV, signal_handle);
	//signal(SIGABRT, signal_handle);
	signal(SEGV_MAPERR, signal_handle);
}

void destructor_into() {
	printf("+++%s: %d\n", __func__, __LINE__);
}


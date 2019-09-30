#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <android/log.h>
#include <cutils/log.h>
#include <sys/ioctl.h>
#include <utils/Log.h>
#include <pthread.h>

#define LOG_TAG "gdb_eg"
#define cpu0_freq_file "/sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_cur_freq"
#define is_cpu0_online_file "/sys/devices/system/cpu/cpu1/online"
#define RUN_TIMES 10000
extern void __gcov_flush();
extern void __gcov_init();

int get_cpu0_online(int num, const char const *p)
{
	int fd = -1;
	int ret = 0;
	int get_times = num;
	int buf = 0;

	ALOGD("get times = %d", get_times);
	fd = open(p ,O_RDONLY, 0);
	if (fd == -1){
		ALOGE("cat not open file %s", p);
		ret = -1;
	} else if (-1 == read(fd, &buf, sizeof(buf))){
		ALOGE("read file %s err", p);
		ret = -1;
	} else {
		ALOGD("read file %s ok", p);
		ret = buf;
	}

	return ret;
}

void *fork_test_func()
{
	for (;;) {
		sleep(1);
		ALOGD("-----run %s:[%d]------pid: %d", __func__, __LINE__, getpid());
	}
}

int get_cpu0_freq(const char const *p)
{
	int fd = -1;
	int ret = -1;
	int buf = 0;

	ALOGD("-----run %s:[%d]------", __func__, __LINE__);
	fd = open(p, O_RDONLY, 0);
	if (-1 == fd){
		ALOGE("Cat not open file %s", p);
		ret = -1;
	} else if (-1 == read(fd, &buf, sizeof(buf))){
		ALOGE("read file %s err", p);
		ret = -1;
	} else {
		ALOGD("read file %s ok", p);
		ret = buf;
	}

	return ret;
}

void gcov_handler_3(int sig){

	ALOGD("gcov_handler: %d", sig);
	__gcov_flush();
}

int main()
{
	int is_cpu0_online, cpu0_freq, i;
	pthread_t t;

	char* gcov_env = getenv("GCOV_PREFIX");
	__gcov_init();

	ALOGD("gcov_handler install, env = %s", gcov_env);
	signal(31, gcov_handler_3);

	pthread_create(&t, NULL, fork_test_func, NULL);

	for (i = 0; i < RUN_TIMES; i++)
	{

		is_cpu0_online = get_cpu0_online(i, is_cpu0_online_file);
		if(2609 != is_cpu0_online)
		{
			ALOGE("cpu0 maybe plug out is_cpu0_online = %d", is_cpu0_online);
//			return 0;
		}

		cpu0_freq = get_cpu0_freq(cpu0_freq_file);
		if (cpu0_freq > 0)
			ALOGD("cpuo freq is %d M pid: %d", cpu0_freq - 808465977 + 960000, getpid());

		ALOGD("sleep 1s");
		sleep(1);
	}

	return 0;

}


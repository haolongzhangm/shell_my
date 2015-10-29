#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <android/log.h>
#include <cutils/log.h>
#include <cutils/xlog.h>
#include <sys/ioctl.h>

#define LOG_TAG "mtkpmureadtest"
#define logFile "/storage/sdcard0/MTKPMU.log"
#define ADC_CHANNEL_READ 		_IOW('k', 4, int)
#define ADC_BAT_FG_CURRENT 66
#define ADC_COUNT  5
#define ADC_BAT_SEN 1

int get_ADC_channel(int adc_channel, int adc_count)
{
	int fd = -1;
	int ret = 0;
	int adc_in_data[2] = {1,1}; 

	fd = open("/dev/MT_pmic_adc_cali",O_RDONLY, 0);
	if (fd == -1) {
		ALOGD("get_ADC_channel - Can't open /dev/MT_pmic_adc_cali\n");
	}

	adc_in_data[0] = adc_channel;
	adc_in_data[1] = adc_count;

	if (fd >= 0) {
		ret = ioctl(fd, ADC_CHANNEL_READ, adc_in_data);
		close(fd);
	}
	else
	{
		ALOGD("fd<0, do nothing\n");
	}

	if (adc_in_data[1]==0) { 
		ALOGD("read channel[%d] %d times : %d\n", adc_channel, adc_count, adc_in_data[0]);		
		return adc_in_data[0];
	}

	return -1;
}

int main()
{
	int logFd;
	int battery_fg_current = 0;
	int bat_voltage = 0;
	char write_buf[50];
	char write_buf_second[50];
	int temp = -1;
	unsigned long long sum = 0;
	unsigned long long count = 0;
	unsigned long power = 0;
	//OPEN LOG FILE
	logFd = open(logFile, O_CREAT | O_RDWR, 0666);
	ALOGD("Read tart ...%s:[%d].\n", __func__, __LINE__);
	if(logFd == -1)
	{
		ALOGE("open TOUCH_FW_UPDATE_NODE failed reason = %s \n", strerror(errno));	
		return 0;
	}
	do{
		//UPDATE I
		temp = get_ADC_channel(ADC_BAT_FG_CURRENT, ADC_COUNT); 
		if (temp != -1) {				
			battery_fg_current = temp;
		} else {
			battery_fg_current = -1;
		}	
		//UPDATE V
		temp = get_ADC_channel(ADC_BAT_SEN, ADC_COUNT); 
		if (temp != -1) {		
			bat_voltage = (temp/ADC_COUNT);
		} else {
			bat_voltage = -1;
		}
		//WRITE TO LOGFILE
		memset(write_buf, 0, sizeof(write_buf));
		memset(write_buf_second, 0, sizeof(write_buf_second));
		ALOGD("%s:[%d]\n", __func__, __LINE__);
		sprintf(write_buf, "battery_fg_curren = %dmA, bat_voltage = %dmV\n", battery_fg_current, bat_voltage);
		if(write(logFd, write_buf, sizeof(write_buf)) == -1)
		{
			ALOGE("write fd errno \n");
			return 0;
		}
		ALOGD("%s:[%d]:battery_fg_current = %dmA;bat_voltage = %dmV\n",  __func__, __LINE__, battery_fg_current, bat_voltage);
		if (battery_fg_current > 0)
		{
			sum = sum + battery_fg_current * bat_voltage;
			count++;
			power = sum/count;
			sprintf(write_buf_second, "power  = %dma.mv\n", power);
			ALOGD("power = %dma.mv\r\n", power);
			if(write(logFd, write_buf_second, sizeof(write_buf_second)) == -1)
			{
				ALOGE("write fd errno \n");
				return 0;
			}
		}
		sync();
		ALOGD("#####over2\n");
		sleep(1);
	}while(1);

	close(logFd);

	return 0;

}


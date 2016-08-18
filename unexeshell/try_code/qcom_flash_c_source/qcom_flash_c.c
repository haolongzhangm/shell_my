#include <dirent.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include<string.h>
#define MAX_TTYUSB_DEV 100

//by haolong.zhang 20180818 v0.1

int find_device(DIR *, char *[]);
int check_sw_needed_file();
int check_argc_argv(int argc, char *argv[]);
void usage();
char * find_spl();

int main(int argc, char *argv[])
{
	DIR *dir;
	char *ttyUSB_dev[MAX_TTYUSB_DEV] = {"NULL"};
	int match_dev_num = 0, i = 0;
	char *spl_name; 
	char ttyUSB_path[10];
	char spl_flash_exec_param[1024];
	char other_flash_exec_param[1024];
	int spl_flash_result = -1;
	int other_flash_result = -1;

	//now we check argc argv
	if (0 != check_argc_argv(argc, argv)){
		printf("%s:[%d] Err, check_argc_argv failed!\n", __func__, __LINE__);
		return -1;
	}

	//now we check the needed file
	if (0 != check_sw_needed_file()){
		printf("%s:[%d] Err, check_sw_needed_file failed!\n", __func__, __LINE__);
		return -1;
	}

	//now we find SPL file
	spl_name = find_spl();
	if (!strncmp(spl_name, "NULL", sizeof("NULL"))){
		printf("%s:[%d] Err, find spl file failed! spl_name = %s\n", __func__, __LINE__, spl_name);
		return -1;
	}else{
		printf("%s:[%d] Success, find spl file! spl_name = %s\n", __func__, __LINE__,spl_name);
	}

	dir = opendir("/dev");
	if (match_dev_num = find_device(dir, ttyUSB_dev) > 0)
	{
		printf("find %d match dev\n", match_dev_num);
		for(i = 0; ttyUSB_dev[i] != NULL; i++)
		{
			printf("Let`s handle %s\n", ttyUSB_dev[i]);
			//check /dev/ttyUSB access mode
			sprintf(ttyUSB_path, "/dev/%s", ttyUSB_dev[i]);
			if (0 == access(ttyUSB_path, R_OK | W_OK))
				printf("%s can be read and write\n", ttyUSB_path);
			else{
				printf("%s can not be read and write\n", ttyUSB_path);
				printf("pls do : sudo adduser $USER dialout\n");
				return -1;
			}

			//now try to flash spl
			//Formatt exe args;eg spl_qcom_download -p /dev/ttyUSB1 -s  13:prog_emmc_firehose_8976_ddr.mbn
			sprintf(spl_flash_exec_param, "spl_qcom_download -p %s -s  13:%s", ttyUSB_path, spl_name);
			printf("Debug: spl_flash_exec_param = %s\n", spl_flash_exec_param);
			if (0 == system(spl_flash_exec_param)){
				spl_flash_result = 0;
				break;
			}
		}
		if (spl_flash_result != 0){
			printf("flash SPL failed \n");
			return -1;
		}

		//try to sleep 3s
		printf("sleep 3s...\n");
		sleep(3);
		//now try to flash all other img
		//Formatt exe args : eg img_qcom_download --port=/dev/ttyUSB1  --sendxml=patch0.xml --search_path=.  --sendxml=rawprogram_unsparse_without_QCN.xml --search_path=. --reset
		if (0 == strncmp(argv[1], "withqcn",sizeof("withqcn"))){
			sprintf(other_flash_exec_param, "img_qcom_download --port=%s  --sendxml=patch0.xml --search_path=.  --sendxml=rawprogram_unsparse.xml --search_path=. --reset", ttyUSB_path);
			printf("Debug: %s", other_flash_exec_param);
		}
		else if(0 == strncmp(argv[1], "withoutqcn",sizeof("withoutqcn"))){
			sprintf(other_flash_exec_param, "img_qcom_download --port=%s  --sendxml=patch0.xml --search_path=.  --sendxml=rawprogram_unsparse_without_QCN.xml --search_path=. --reset", ttyUSB_path);
			printf("Debug: %s", other_flash_exec_param);
		}
		else{
				printf("Err wrong argv\n");
				usage();
				return -1;
			}

		if (0 == system(other_flash_exec_param)){
			other_flash_result = 0;
			printf("Flash all img with %s Success\n", argv[1]);
		}else{
			printf("Flsh all img failed\n");
		}
 

	}else{
		printf("can not find a ttyUSB dev, pls set phone to 9008 mode,eg:adb reboot edl\n");
		printf("%s:[%d] Err, stop!\n", __func__, __LINE__);
		closedir(dir);
		return -1;
	}

	closedir(dir);
}

int find_device(DIR *dir, char *ttyUSB_dev[])
{
	int match_dev_num = 0;
	struct dirent *dev_devices;

	while ((dev_devices = readdir(dir)) !=  NULL){
		//printf("debug: %s\n", dev_devices->d_name);
		if (0 == strncmp(dev_devices->d_name, "ttyUSB", strlen("ttyUSB")))
		{
			printf("find match dev %s\n", dev_devices->d_name);
			ttyUSB_dev[match_dev_num] = dev_devices->d_name;
			match_dev_num++;
		}
	}

	return match_dev_num;
}

//ret = 0 :find all needed file
//ret = -1 :some needed file can not find
int check_sw_needed_file()
{
	DIR *dir;
	struct dirent *sw_dir_file;
	int ret = 0, i = 0;
	char *check_file_list[] = {"NON-HLOS.bin", "boot.img", "emmc_appsboot.mbn", "patch0.xml", "rawprogram_unsparse_without_QCN.xml", "rawprogram_unsp", "NULL"};

	while (check_file_list[i] != "NULL"){
		printf("now check file %s\n", check_file_list[i]);
		ret = -1;
		dir = opendir(".");
		while ((sw_dir_file = readdir(dir)) != NULL){
			//printf("debug: sw_dir_file->d_name = %s\n", sw_dir_file->d_name);
			if (0 == strncmp(check_file_list[i], sw_dir_file->d_name, strlen(check_file_list[i]))){
				printf("Find check file %s\n\n", check_file_list[i]);
				ret = 0;
				closedir(dir);
				break;
			}
		}
		if (-1 == ret){
			printf("Err can not find %s\n", check_file_list[i]);
			printf("check needed file failed , pls cd IMAGES_FOR_QMSCT fisrtly\n");
			closedir(dir);
			return ret;
		}
		i++;
	}

	return ret;
}

char * find_spl()
{
	int num_spl = 0;
	DIR *dir;
	struct dirent *spl_dir_file;
	char *spl_name = "NULL";

	dir = opendir(".");
	while ((spl_dir_file = readdir(dir)) != NULL){
		if ( 0 == strncmp(spl_dir_file->d_name, "prog_emmc_firehose", strlen("prog_emmc_firehose"))){
			printf("Find spl name :%s\n\n", spl_dir_file->d_name);
			spl_name = spl_dir_file->d_name;
			num_spl++;
		}

	}
	if (num_spl > 1)
	{
		printf("Err more than one spl file ,num = %d\n", num_spl);
		return "NULL";
	}

	return spl_name;
}

//ret = 0 :success
int check_argc_argv(int argc, char *argv[])
{
	int ret = -1;

	if (argc != 2){
		printf("ERR:need one param\n");
		usage();
		return ret;
	}
	if (strncmp(argv[1], "withqcn",sizeof("withqcn")) && strncmp(argv[1], "withoutqcn",sizeof("withoutqcn"))){
		printf("ERR:param should be withqcn or withoutqcn\n\n");
		usage();
		return ret;
	}

	ret = 0;
	return ret;
}

void usage()
{
	printf("Usage:\n");
	printf("	v0.1 2018.8.18 by zhl\n");
	printf("	qcom_flash_c withqcn\n");
	printf("	qcom_flash_c withoutqcn\n\n\n");
}

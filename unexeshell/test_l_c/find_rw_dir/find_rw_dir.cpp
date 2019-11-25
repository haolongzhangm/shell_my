#include "find_rw_dir.h"
#include <android/log.h>
#include <dirent.h>
#include <fstream>
#include <iostream>
#include <pthread.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#define TAG "DDDDD"
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, TAG, __VA_ARGS__)
#define CHECK_DATABASE "/data/find_rw_dir_database.log"

// if android opt dlopen lib, need call this func
// always do not need call this func
void __attribute__((constructor)) find_rw_dir_thread(void);

void triger_openlib() { LOGE("just triger linker open lib"); }

void *loop_func(void *data) {
  LOGE("start check...");
  std::ifstream in(CHECK_DATABASE, std::fstream::in);
  if (!in) {
    LOGE("can not find(or no permisson) CHECK_DATABASE at: %s\n",
         CHECK_DATABASE);
    LOGE("create database by command: find -L /  -path /proc -prune -o -print "
         "-path /sys -prune -o -print -path /dev -prune -o -print > %s",
         CHECK_DATABASE);
    return data;
  }

#define len 1024
  char str[len];

  while (in) {
    in.getline(str, len);
    if (in) {
      struct stat s;
      stat(str, &s);
      if ((0 == access(str, W_OK | R_OK)) && (S_ISDIR(s.st_mode))) {
        std::ofstream mode_file;
        auto s = std::string(str) + "/mode.log";
        const char *mode_s = s.c_str();
        mode_file.open(mode_s, std::fstream::out);
        if (!mode_file)
          LOGE("con not create file: %s", mode_s);
        else
          LOGE("FIND RW dir: %s", str);
      }
    }
  }
  in.close();
#undef len

  LOGE("end check...");

  return data;
}

void find_rw_dir_thread() {
  pthread_t t;
  LOGE("%s: start!", __func__);
  pthread_create(&t, NULL, loop_func, NULL);
  pthread_join(t, NULL);
}

int main() { find_rw_dir_thread(); }

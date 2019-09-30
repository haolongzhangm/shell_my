LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_CFLAGS += -g -O0
LOCAL_SHARED_LIBRARIES := \
		libutils \
		liblog 
LOCAL_CFLAGS := -fprofile-arcs -ftest-coverage -O0 -DGCOV_TOOL -coverage -lgcov
LOCAL_LDFLAGS := -fprofile-arcs -ftest-coverage -O0 -DGCOV_TOOL -coverage -lgcov
LOCAL_MODULE    := gdb_eg
LOCAL_SRC_FILES := gdb_eg.c
#LOCAL_32_BIT_ONLY := true
include $(BUILD_EXECUTABLE)


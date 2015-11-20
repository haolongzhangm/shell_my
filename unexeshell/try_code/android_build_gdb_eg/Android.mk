LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_SHARED_LIBRARIES := \
		libutils \
		liblog 
LOCAL_MODULE    := gdb_eg
LOCAL_SRC_FILES := gdb_eg.c
include $(BUILD_EXECUTABLE)


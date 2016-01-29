LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := user_space_core_dump_eg
LOCAL_SRC_FILES := user_space_core_dump_eg.c \
	
include $(BUILD_EXECUTABLE)

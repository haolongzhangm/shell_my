LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_SHARED_LIBRARIES := \
		libutils \
		liblog 
LOCAL_MODULE    := mtkmt66sepmuread
LOCAL_SRC_FILES := mtkmt66sepmuread.c
include $(BUILD_EXECUTABLE)


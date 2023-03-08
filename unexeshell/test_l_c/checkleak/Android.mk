LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE:= libcheckleak

LOCAL_SRC_FILES := checkleak.cpp

LOCAL_MULTILIB := both

LOCAL_SHARED_LIBRARIES := libbacktrace liblog libc_malloc_debug
include $(BUILD_SHARED_LIBRARY)

include $(call all-makefiles-under,$(LOCAL_PATH))

# Overrides:
# 	external/wpa_supplicant_8/wpa_supplicant/wpa_supplicant_conf.mk

LOCAL_PATH := $(call my-dir)

########################
include $(CLEAR_VARS)

LOCAL_MODULE               := wpa_supplicant_xenvm.conf
LOCAL_OVERRIDES_PACKAGES   := wpa_supplicant.conf
LOCAL_SRC_FILES            := wpa_supplicant.conf
LOCAL_MODULE_CLASS         := ETC
LOCAL_MODULE_PATH          := $(TARGET_OUT_VENDOR)/etc/wifi

include $(BUILD_PREBUILT)
########################

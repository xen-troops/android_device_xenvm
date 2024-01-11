#
# Copyright (C) 2016 The Android Open-Source Project
# Copyright (C) 2018 EPAM Systems Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE := true

BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

TARGET_BOOTLOADER_BOARD_NAME := xenvm
TARGET_COPY_OUT_VENDOR := vendor

TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false
TARGET_NO_RADIOIMAGE := true
TARGET_NO_RECOVERY := true
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888

TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a15

TARGET_USES_64_BIT_BINDER := true
TARGET_USES_MKE2FS := true
TARGET_USES_HWC2 := true

BOARD_USES_UNCOMPRESSED_BOOT := false
BOARD_USES_GENERIC_AUDIO := false
BOARD_USES_ALSA_AUDIO := true

AUDIOSERVER_MULTILIB := 64

BOARD_USE_64BITMEDIA := true
TARGET_ENABLE_MEDIADRM_64 := true

USE_CAMERA_STUB := true
USE_OPENGL_RENDERER := true

# Android images
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_FLASH_BLOCK_SIZE := 512

BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_BOOTIMAGE_PARTITION_SIZE := 33497088
BOARD_USERDATAIMAGE_PARTITION_SIZE := 3145728000  # 3145728000 = 3000 MiB

BOARD_USES_RECOVERY_AS_BOOT := true
BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true

# Dynamic partitions:
# One slot BOARD_XVM_SIZE (2415919104) + metadata (8388608) = 2424307712
# Two slots 4848615424

BOARD_SUPER_PARTITION_SIZE := 4848615424
BOARD_SUPER_PARTITION_GROUPS := group_xvm
BOARD_GROUP_XVM_SIZE := 2417919104
BOARD_GROUP_XVM_PARTITION_LIST := system vendor

# Verified boot
ifneq ($(DISABLE_AVB),true)
BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA512_RSA4096
BOARD_AVB_SYSTEM_ADD_HASHTREE_FOOTER_ARGS := --do_not_generate_fec
BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS := --do_not_generate_fec
endif


# Enable dex-preoptimization to speed up first boot sequence, only for USER build
ifeq ($(HOST_OS),linux)
  ifeq ($(TARGET_BUILD_VARIANT),user)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
    endif
  endif
endif

ART_USE_HSPACE_COMPACT := true

# SECCOMP device specific policy dir
BOARD_SECCOMP_POLICY += device/xen/xenvm/seccomp

# SELinux support
BOARD_VENDOR_SEPOLICY_DIRS += device/xen/xenvm/sepolicy/vendor
BOARD_VENDOR_SEPOLICY_DIRS += device/xen/xenvm/sepolicy/private
BOARD_VENDOR_SEPOLICY_DIRS += device/xen/xenvm/sepolicy/public


# Boot image build rules
BOARD_KERNEL_CMDLINE :=
BOARD_KERNEL_BASE := 0x48000000
BOARD_MKBOOTIMG_ARGS := --second_offset 0x800 --kernel_offset 0x200000 --ramdisk_offset 0x1300000
ifeq ($(TARGET_PREBUILT_KERNEL),)
TARGET_KERNEL_SOURCE := device/xen/kernel
TARGET_KERNEL_CONFIG := android_xenvm_defconfig
endif

# Disable Jack
ANDROID_COMPILE_WITH_JACK := false

BOARD_USES_DRM_HWCOMPOSER := true

BOARD_USES_METADATA_PARTITION=true

DEVICE_MANIFEST_FILE             := device/xen/xenvm/manifest.xml
DEVICE_MATRIX_FILE               := device/xen/xenvm/compatibility_matrix.xml
BOARD_VNDK_VERSION               := current

# Wi-Fi
ifeq ($(BOARD_WIFI_VENDOR), realtek)
    WPA_SUPPLICANT_VERSION := VER_0_8_X
    BOARD_WPA_SUPPLICANT_DRIVER := NL80211
    BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_rtl
    BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_rtl
    BOARD_HOSTAPD_DRIVER := NL80211
    BOARD_WLAN_DEVICE := realtek
endif

SOONG_CONFIG_NAMESPACES += vhal
SOONG_CONFIG_vhal += vhal_type
SOONG_CONFIG_vhal_vhal_type = viss

BOARD_VENDOR_SEPOLICY_DIRS += \
    vendor/epam/aosp-vhal/vehicle/sepolicy \

BOARD_VENDOR_SEPOLICY_DIRS += \
    vendor/xen/gnss/sepolicy \

BOARD_HAVE_BLUETOOTH := true

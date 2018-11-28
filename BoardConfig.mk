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

TARGET_BOOTLOADER_BOARD_NAME := xenvm
TARGET_COPY_OUT_VENDOR := vendor

TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false
TARGET_NO_RADIOIMAGE := true
TARGET_NO_RECOVERY := true

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

USE_CAMERA_STUB := true
USE_OPENGL_RENDERER := true

# Android images
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_FLASH_BLOCK_SIZE := 512
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2147483648
BOARD_USERDATAIMAGE_PARTITION_SIZE := 25846856704
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 268435456
BOARD_BOOTIMAGE_PARTITION_SIZE := 20971520
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true

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
BOARD_SEPOLICY_DIRS += device/xen/xenvm/sepolicy

ifeq ($(TARGET_PREBUILT_KERNEL),)
# Kernel build rules
BOARD_KERNEL_CMDLINE :=
BOARD_KERNEL_BASE := 0x48000000
BOARD_MKBOOTIMG_ARGS := --second_offset 0x800 --kernel_offset 0x80000 --ramdisk_offset 0x1100000
TARGET_KERNEL_SOURCE := device/xen/kernel
TARGET_KERNEL_CONFIG := android_xenvm_defconfig
endif

PVRSRV_VZ_NUM_OSID := 2

# Disable Jack
ANDROID_COMPILE_WITH_JACK := false

BOARD_USES_DRM_HWCOMPOSER := true

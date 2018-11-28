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

# IMG DDK Targets & dependencies
ifneq (,$(filter r8a7795 r8a7796, $(TARGET_BOARD_PLATFORM)))

ABS_TOP := $(abspath $(TOP))

TARGET_KERNEL_MODULES_OUT := $(PRODUCT_OUT)/obj/KERNEL_MODULES

BOARD_VENDOR_KERNEL_MODULES += \
	$(TARGET_KERNEL_MODULES_OUT)/pvrsrvkm.ko \

ifneq ($(TARGET_SOC_REVISION),)
TARGET_SOC_PLATFORM_REVISION := $(TARGET_BOARD_PLATFORM)_$(TARGET_SOC_REVISION)
else
TARGET_SOC_PLATFORM_REVISION := $(TARGET_BOARD_PLATFORM)
endif

ifeq ($(DDK_UM_PREBUILDS),)
# Build DDK-UM
DDK_UM_DEP=img_ddk_um
$(call inherit-product-if-exists, vendor/imagination/clang/device-vendor.mk)
$(call inherit-product-if-exists, vendor/imagination/llvm/device-vendor.mk)
PRODUCT_PACKAGES += $(DDK_UM_DEP)
else
# Use DDK-UM from prebuilds
$(call inherit-product-if-exists, $(DDK_UM_PREBUILDS)/prebuilds.mk)
endif # DDK_UM_PREBUILDS


ifeq ($(TARGET_PREBUILT_KERNEL),)
# Rule for building DDK-KM module

HOSTCC=$(ABS_TOP)/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.15-4.8/bin/x86_64-linux-gcc
ANDROID_TOOLCHAIN_XX=$(ABS_TOP)/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin
CROSS_COMPILE="$(ANDROID_TOOLCHAIN_XX)/aarch64-linux-android-"

RGX_MODULE:
	make -C vendor/imagination/rogue_km/build/linux/$(TARGET_SOC_PLATFORM_REVISION)_android KERNELDIR=$(KERNEL_OUT) \
        PVRSRV_VZ_NUM_OSID=$(PVRSRV_VZ_NUM_OSID) ANDROID_ROOT=$(ABS_TOP) CROSS_COMPILE=$(CROSS_COMPILE) ARCH="arm64"\
        OUT=$(PRODUCT_OUT)/obj/ROGUE_KM_OBJ HOST_CC=$(HOSTCC) KERNEL_CROSS_COMPILE=$(CROSS_COMPILE)
	mv $(PRODUCT_OUT)/obj/ROGUE_KM_OBJ/target_aarch64/kbuild/pvrsrvkm.ko $(TARGET_KERNEL_MODULES_OUT)

TARGET_KERNEL_EXT_MODULES += RGX_MODULE
$(BOARD_VENDOR_KERNEL_MODULES) : $(ABS_TOP)/device/xen/kernel $(DDK_UM_DEP) RGX_MODULE

else
# Use DDK-KM module from prebuilds

RGX_MODULE:
	mkdir -p $(TARGET_KERNEL_MODULES_OUT)
	cp $(DDK_KM_PREBUILT_MODULE)  $(TARGET_KERNEL_MODULES_OUT)

$(BOARD_VENDOR_KERNEL_MODULES) : RGX_MODULE $(DDK_UM_DEP)

endif # TARGET_PREBUILT_KERNEL

# Global for IMG DDK

PRODUCT_PACKAGES += \
    android.hardware.graphics.common@1.0-impl \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.renderscript@1.0-impl \
    libion \
    libdrm \
    libLLVM \

endif


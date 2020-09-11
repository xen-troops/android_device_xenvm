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
TARGET_ARCH := arm64

DDK_UM_PREBUILDS ?= $(ABS_TOP)/vendor/imagination/rogue_um

TARGET_KERNEL_MODULES_OUT := $(abspath ${OUT_DIR}/target/product/$(TARGET_PRODUCT)/obj/KERNEL_MODULES)

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

ifeq ($(DDK_BUILD_OPENCL),true)
$(call inherit-product-if-exists, vendor/imagination/clang/device-vendor.mk)
$(call inherit-product-if-exists, vendor/imagination/llvm/device-vendor.mk)
endif

PRODUCT_PACKAGES += $(DDK_UM_DEP)
else
# Use DDK-UM from prebuilds
$(call inherit-product-if-exists, $(DDK_UM_PREBUILDS)/prebuilds.mk)
endif # DDK_UM_PREBUILDS


ifeq ($(DDK_KM_PREBUILT_MODULE),)
# Rule for building DDK-KM module


KM_TOP := $(ABS_TOP)/vendor/imagination/rogue_km/
KERNEL_MAKE := $(abspath ./prebuilts/build-tools/linux-x86/bin/make)
KERNEL_OUT := $(OUT_DIR)/target/product/$(TARGET_PRODUCT)/obj/KERNEL_OBJ
KERNEL_TARGET_BINARY := $(KERNEL_OUT)/arch/$(TARGET_ARCH)/boot/Image

GCC_CROSS_COMPILE := $(abspath ./prebuilts/gcc/linux-x86/aarch64/aarch64-linux-gnu/bin/aarch64-linux-gnu-)
DDK_CROSS_COMPILE := $(abspath ./prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-)
ANDROID_CLANG_TOOLCHAIN := $(abspath ./prebuilts/clang/host/linux-x86/clang-r353983c/bin/clang)

KERNEL_CFLAGS := HOSTCFLAGS="-fuse-ld=lld" HOSTLDFLAGS=-fuse-ld=lld ARCH=$(TARGET_ARCH)
KERNEL_CFLAGS += CC=$(ANDROID_CLANG_TOOLCHAIN) CLANG_TRIPLE=$(GCC_CROSS_COMPILE) CROSS_COMPILE=$(GCC_CROSS_COMPILE) HOST_CC=$(ANDROID_CLANG_TOOLCHAIN)
KERNEL_CFLAGS += PVRSRV_VZ_NUM_OSID=$(PVRSRV_VZ_NUM_OSID) ANDROID_ROOT=$(ABS_TOP) TOP=$(KM_TOP) KERNEL_CROSS_COMPILE=$(DDK_CROSS_COMPILE)

$(BOARD_VENDOR_KERNEL_MODULES) : $(KERNEL_TARGET_BINARY) $(DDK_UM_VENDOR_TARGET_FILES)
	TEMPORARY_DISABLE_PATH_RESTRICTIONS=true $(KERNEL_MAKE) -C $(KM_TOP)/build/linux/$(TARGET_SOC_PLATFORM_REVISION)_android KERNELDIR=$(KERNEL_OUT) \
	OUT=$(PRODUCT_OUT)/obj/ROGUE_KM_OBJ $(KERNEL_CFLAGS)
	mv $(PRODUCT_OUT)/obj/ROGUE_KM_OBJ/target_aarch64/kbuild/pvrsrvkm.ko $(TARGET_KERNEL_MODULES_OUT)


else
# Use DDK-KM module from prebuilds

$(BOARD_VENDOR_KERNEL_MODULES):
	mkdir -p $(TARGET_KERNEL_MODULES_OUT)
	cp $(DDK_KM_PREBUILT_MODULE)  $(TARGET_KERNEL_MODULES_OUT)

endif # DDK_KM_PREBUILT_MODULE

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


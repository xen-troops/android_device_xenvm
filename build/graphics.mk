#
# Copyright (C) 2016 The Android Open-Source Project
# Copyright (C) 2021 EPAM Systems Inc.
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

TOP_ABS                     := $(abspath $(TOP))
ANDROID_CLANG_TOOLCHAIN_ABS := $(abspath ./prebuilts/clang/host/linux-x86/clang-r353983c/bin/clang)
DDK_KM_OUT_ABS              := $(abspath $(PRODUCT_OUT)/obj/ROGUE_KM_OBJ)
DDK_CROSS_COMPILE_ABS       := $(abspath ./prebuilts/gcc/linux-x86/aarch64/aarch64-linux-gnu/bin/aarch64-linux-gnu-)
PVRSRV_VZ_NUM_OSID          := 2

BOARD_VENDOR_KERNEL_MODULES += \
	$(KERNEL_MODULES_OUT)/pvrsrvkm.ko \

ifneq ($(TARGET_SOC_REVISION),)
TARGET_SOC_PLATFORM_REVISION := $(TARGET_BOARD_PLATFORM)_$(TARGET_SOC_REVISION)
else
TARGET_SOC_PLATFORM_REVISION := $(TARGET_BOARD_PLATFORM)
endif

ifeq ($(DDK_UM_PREBUILDS),)

DDK_UM_PREBUILDS ?= $(TOP_ABS)/vendor/imagination/rogue_um

# Build DDK-UM
DDK_UM_DEP=img_ddk_um

ifeq ($(DDK_BUILD_OPENCL),true)
$(call inherit-product-if-exists, vendor/imagination/clang/device-vendor.mk)
$(call inherit-product-if-exists, vendor/imagination/llvm/device-vendor.mk)
endif

PRODUCT_PACKAGES += $(DDK_UM_DEP)
endif # DDK_UM_PREBUILDS

# Use DDK-UM from prebuilds
$(call inherit-product, $(DDK_UM_PREBUILDS)/$(TARGET_BOARD_PLATFORM)/prebuilds.mk)

ifeq ($(DDK_KM_PREBUILT_MODULE),)

DDK_KM_SOURCE_ABS := $(TOP_ABS)/vendor/imagination/rogue_km

# Rule for building DDK-KM module

DDK_KM_CFLAGS := HOSTCFLAGS="-fuse-ld=lld" HOSTLDFLAGS=-fuse-ld=lld ARCH=arm64
DDK_KM_CFLAGS += CROSS_COMPILE=$(DDK_CROSS_COMPILE_ABS) HOST_CC=$(ANDROID_CLANG_TOOLCHAIN_ABS)
DDK_KM_CFLAGS += PVRSRV_VZ_NUM_OSID=$(PVRSRV_VZ_NUM_OSID) ANDROID_ROOT=$(TOP_ABS) TOP=$(DDK_KM_SOURCE_ABS)

$(BOARD_VENDOR_KERNEL_MODULES) : $(KERNEL_MODULES)
	TEMPORARY_DISABLE_PATH_RESTRICTIONS=true $(ANDROID_MAKE) -C $(DDK_KM_SOURCE_ABS)/build/linux/$(TARGET_SOC_PLATFORM_REVISION)_android KERNELDIR=$(KERNEL_OUT_ABS) \
	OUT=$(DDK_KM_OUT_ABS) CC=$(ANDROID_CLANG_TOOLCHAIN_ABS) CLANG_TRIPLE=$(DDK_CROSS_COMPILE_ABS)  HOST_CC=$(ANDROID_CLANG_TOOLCHAIN_ABS)  \
	HOST_CXX=$(ANDROID_CLANG_TOOLCHAIN_ABS)  KERNEL_CROSS_COMPILE=$(DDK_CROSS_COMPILE_ABS) $(DDK_KM_CFLAGS)
	mv $(PRODUCT_OUT)/obj/ROGUE_KM_OBJ/target_aarch64/kbuild/pvrsrvkm.ko $(KERNEL_MODULES_OUT)


else
# Use DDK-KM module from prebuilds

$(BOARD_VENDOR_KERNEL_MODULES):
	mkdir -p $(KERNEL_MODULES_OUT)
	cp $(DDK_KM_PREBUILT_MODULE)  $(KERNEL_MODULES_OUT)

endif # DDK_KM_PREBUILT_MODULE

# Global for IMG DDK

PRODUCT_PACKAGES += \
    android.hardware.graphics.common@1.0-impl \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.graphics.allocator@3.0-impl.xenvm \
    android.hardware.graphics.allocator@3.0-service.xenvm \
    android.hardware.renderscript@1.0-impl \
    libion \
    libdrm \
    libLLVM \

endif


#
# Copyright (C) 2019 GlobalLogic
# Copyright (C) 2021 EPAM systems
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
#

ifeq ($(KERNEL_MODULES_OUT),)
$(error "KERNEL_MODULES_OUT is not set")
endif

ifeq ($(PRODUCT_OUT),)
$(error "PRODUCT_OUT is not set")
endif

# Realtek Wi-Fi driver
#BOARD_VENDOR_KERNEL_MODULES += \
#	$(KERNEL_MODULES_OUT)/8812au.ko

WLAN_KM_SRC             := hardware/realtek/rtl8812au_km
WLAN_KM_OUT             := $(PRODUCT_OUT)/obj/WLAN_KM_OBJ
WLAN_KM_OUT_ABS         := $(abspath $(WLAN_KM_OUT))
WLAN_KM                 := $(WLAN_KM_OUT)/8812au.ko

$(WLAN_KM):
	mkdir -p $(WLAN_KM_OUT_ABS)
	cp -pR $(WLAN_KM_SRC)/* $(WLAN_KM_OUT_ABS)/
	PATH=$(ANDROID_MAKE_PATH):$$PATH $(ANDROID_MAKE) -C $(WLAN_KM_OUT_ABS) $(KERNEL_CFLAGS) \
		KERNELDIR=$(KERNEL_OUT_ABS) \
		WORKDIR=$(WLAN_KM_OUT_ABS) rcar_defconfig
	PATH=$(ANDROID_MAKE_PATH):$$PATH $(ANDROID_MAKE) -C $(WLAN_KM_OUT_ABS) $(KERNEL_CFLAGS) \
		KERNELDIR=$(KERNEL_OUT_ABS) WORKDIR=$(WLAN_KM_OUT_ABS) \
		M=$(WLAN_KM_OUT_ABS) modules
	cp $(WLAN_KM) $(KERNEL_MODULES_OUT)/

KERNEL_EXT_MODULES += \
	$(WLAN_KM)

BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
	$(BOARD_RECOVERY_KERNEL_MODULES)

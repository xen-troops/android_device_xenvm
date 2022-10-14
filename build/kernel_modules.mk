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

BOARD_VENDOR_KERNEL_MODULES += \
	$(KERNEL_MODULES_OUT)/vspm.ko \
	$(KERNEL_MODULES_OUT)/vspm_if.ko \
	$(KERNEL_MODULES_OUT)/mmngr.ko \
	$(KERNEL_MODULES_OUT)/mmngrbuf.ko \
	$(KERNEL_MODULES_OUT)/uvcs_drv.ko

BOARD_VENDOR_KERNEL_MODULES += \
	$(KERNEL_MODULES_OUT)/phy-rcar-gen3-usb2.ko \
	$(KERNEL_MODULES_OUT)/renesas_usbhs.ko \
	$(KERNEL_MODULES_OUT)/ehci-hcd.ko \
	$(KERNEL_MODULES_OUT)/ehci-platform.ko \
	$(KERNEL_MODULES_OUT)/ohci-hcd.ko \
	$(KERNEL_MODULES_OUT)/ohci-platform.ko \
	$(KERNEL_MODULES_OUT)/xhci-hcd.ko \
	$(KERNEL_MODULES_OUT)/xhci-plat-hcd.ko \
	$(KERNEL_MODULES_OUT)/usb-storage.ko

BOARD_VENDOR_KERNEL_MODULES += \
	$(KERNEL_MODULES_OUT)/rtlwifi.ko \
	$(KERNEL_MODULES_OUT)/rtl_usb.ko \
	$(KERNEL_MODULES_OUT)/rtl8192c-common.ko \
	$(KERNEL_MODULES_OUT)/rtl8192cu.ko

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

VSPM_KM_SRC             := hardware/renesas/modules/vspm/vspm-module
VSPM_KM_OUT             := $(PRODUCT_OUT)/obj/VSPM_KM_OBJ
VSPM_KM_OUT_ABS         := $(abspath $(VSPM_KM_OUT))
VSPM_KM                 := $(VSPM_KM_OUT)/vspm-module/files/vspm/drv/vspm.ko

VSPMIF_KM_SRC           := hardware/renesas/modules/vspmif/vspm_if-module
VSPMIF_KM_OUT           := $(PRODUCT_OUT)/obj/VSPMIF_KM_OBJ
VSPMIF_KM_OUT_ABS       := $(abspath $(VSPMIF_KM_OUT))
VSPMIF_KM               := $(VSPMIF_KM_OUT)/vspm_if-module/files/vspm_if/drv/vspm_if.ko

MMNGR_KM_SRC            := hardware/renesas/modules/mmngr/mmngr_drv/mmngr/mmngr-module/files/mmngr
MMNGR_KM_OUT            := $(PRODUCT_OUT)/obj/MMNGR_KM_OBJ
MMNGR_KM_OUT_ABS        := $(abspath $(MMNGR_KM_OUT))
MMNGR_KM                := $(MMNGR_KM_OUT)/mmngr/drv/mmngr.ko

MMNGRBUF_KM_SRC         := hardware/renesas/modules/mmngr/mmngr_drv/mmngrbuf/mmngrbuf-module/files/mmngrbuf
MMNGRBUF_KM_OUT         := $(PRODUCT_OUT)/obj/MMNGRBUF_KM_OBJ
MMNGRBUF_KM_OUT_ABS     := $(abspath $(MMNGRBUF_KM_OUT))
MMNGRBUF_KM             := $(MMNGRBUF_KM_OUT)/mmngrbuf/drv/mmngrbuf.ko

UVCS_KM_SRC             := hardware/renesas/modules/uvcs
UVCS_KM_OUT             := $(PRODUCT_OUT)/obj/UVCS_KM_OBJ
UVCS_KM_OUT_ABS         := $(abspath $(UVCS_KM_OUT))
UVCS_KM                 := $(UVCS_KM_OUT)/src/makefile/uvcs_drv.ko

# vspm module
$(VSPM_KM):
	mkdir -p $(VSPM_KM_OUT_ABS)
	cp -pR $(VSPM_KM_SRC) $(VSPM_KM_OUT_ABS)
	PATH=$(ANDROID_MAKE_PATH):$$PATH $(ANDROID_MAKE) -C $(VSPM_KM_OUT_ABS)/vspm-module/files/vspm/drv \
		$(KERNEL_CFLAGS) KERNELDIR=$(KERNEL_OUT_ABS) \
		PWD=$(VSPM_KM_OUT_ABS)/vspm-module/files/vspm/drv/
	cp $(VSPM_KM) $(KERNEL_MODULES_OUT)/

# vspm-if module
$(VSPMIF_KM): $(VSPM_KM)
	mkdir -p $(VSPMIF_KM_OUT_ABS)
	cp -pR $(VSPMIF_KM_SRC) $(VSPMIF_KM_OUT_ABS)
	PATH=$(ANDROID_MAKE_PATH):$$PATH $(ANDROID_MAKE) -C $(VSPMIF_KM_OUT_ABS)/vspm_if-module/files/vspm_if/drv/ \
		$(KERNEL_CFLAGS) CP=cp KERNELDIR=$(KERNEL_OUT_ABS) \
		PWD=$(VSPMIF_KM_OUT_ABS)/vspm_if-module/files/vspm_if/drv/ \
		KBUILD_EXTRA_SYMBOLS="$(VSPM_KM_OUT_ABS)/vspm-module/files/vspm/drv/Module.symvers"
	cp $(VSPMIF_KM) $(KERNEL_MODULES_OUT)/

# mmngr module
$(MMNGR_KM):
	mkdir -p $(MMNGR_KM_OUT_ABS)
	cp -pR $(MMNGR_KM_SRC) $(MMNGR_KM_OUT_ABS)
	PATH=$(ANDROID_MAKE_PATH):$$PATH $(ANDROID_MAKE) -C $(MMNGR_KM_OUT_ABS)/mmngr/drv \
		$(KERNEL_CFLAGS) KERNELDIR=$(KERNEL_OUT_ABS) \
		KERNEL_SRC=$(KERNEL_SRC) \
		PWD=$(MMNGR_KM_OUT_ABS)/mmngr/drv \
		MMNGR_CONFIG=MMNGR_SALVATORX \
		MMNGR_SSP_CONFIG="MMNGR_SSP_DISABLE" \
		MMNGR_IPMMU_MMU_CONFIG="IPMMU_MMU_DISABLE"
	cp $(MMNGR_KM) $(KERNEL_MODULES_OUT)/

# mmngrbuf module
$(MMNGRBUF_KM):
	mkdir -p $(MMNGRBUF_KM_OUT_ABS)
	cp -pR $(MMNGRBUF_KM_SRC) $(MMNGRBUF_KM_OUT_ABS)
	PATH=$(ANDROID_MAKE_PATH):$$PATH $(ANDROID_MAKE) -C $(MMNGRBUF_KM_OUT_ABS)/mmngrbuf/drv \
		$(KERNEL_CFLAGS) KERNELDIR=$(KERNEL_OUT_ABS) \
		PWD=$(MMNGRBUF_KM_OUT_ABS)/mmngrbuf/drv \
		MMNGR_CONFIG=MMNGR_SALVATORX \
		MMNGR_SSP_CONFIG="MMNGR_SSP_DISABLE" \
		MMNGR_IPMMU_MMU_CONFIG="IPMMU_MMU_DISABLE"
	cp $(MMNGRBUF_KM) $(KERNEL_MODULES_OUT)/

# UVCS module
$(UVCS_KM):
	mkdir -p $(UVCS_KM_OUT_ABS)
	cp -pR $(UVCS_KM_SRC)/include $(UVCS_KM_OUT_ABS)/
	cp -pR $(UVCS_KM_SRC)/src $(UVCS_KM_OUT_ABS)/
	PATH=$(ANDROID_MAKE_PATH):$$PATH TOP=. $(ANDROID_MAKE) -C $(UVCS_KM_OUT_ABS)/src/makefile \
	    $(KERNEL_CFLAGS) KERNELDIR=$(KERNEL_OUT_ABS)
	cp $(UVCS_KM) $(KERNEL_MODULES_OUT)/

KERNEL_EXT_MODULES += \
	$(VSPM_KM) \
	$(VSPMIF_KM) \
	$(MMNGR_KM) \
	$(MMNGRBUF_KM) \
	$(UVCS_KM)

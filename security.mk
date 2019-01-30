#
# Copyright (C) 2016 The Android Open-Source Project
# Copyright (C) 2019 EPAM Systems Inc.
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

PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-service.optee \
    dba51a17-0563-11e7-93b1-6fa7b0071a51.ta \
    android.hardware.gatekeeper@1.0-service.optee \
    4d573443-6a56-4272-ac6f-2425af9ef9bb.ta \
    libteec \
    tee-supplicant \

# settings for building of trusted applications (TA)
OPTEE_OS_DIR := vendor/xen/optee_os
OPTEE_TA_TARGETS := ta_arm64
OPTEE_CFG_ARM64_CORE := y
BUILD_OPTEE_MK := $(OPTEE_OS_DIR)/mk/aosp_optee.mk
OPTEE_EXTRA_FLAGS := \
    CFG_VIRTUALIZATION=y \
    CFG_SYSTEM_PTA=y \
    CFG_ASN1_PARSER=y \
    CFG_CORE_MBEDTLS_MPI=n \

# for available FLAVOR options see optee-os/core/arch/arm/plat-rcar/conf.mk
ifeq ($(TARGET_BOARD_PLATFORM),r8a7795)
OPTEE_PLATFORM := rcar
OPTEE_PLATFORM_FLAVOR := salvator_h3
endif
ifeq ($(TARGET_BOARD_PLATFORM),r8a7796)
OPTEE_PLATFORM := rcar
OPTEE_PLATFORM_FLAVOR := salvator_m3
endif

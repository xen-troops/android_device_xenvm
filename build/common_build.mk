#
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

ANDROID_CLANG_TOOLCHAIN  := $(abspath ./prebuilts/clang/host/linux-x86/clang-r353983c/bin/clang)
ANDROID_MAKE             := $(abspath ./prebuilts/build-tools/linux-x86/bin/make)
ANDROID_MAKE_PATH        := $(abspath ./prebuilts/build-tools/linux-x86/bin/)
BSP_GCC_CROSS_COMPILE    := $(abspath ./prebuilts/gcc/linux-x86/aarch64/aarch64-linux-gnu/bin/aarch64-linux-gnu-)
PRODUCT_OUT              := $(OUT_DIR)/target/product/$(TARGET_PRODUCT)
KERNEL_MODULES_OUT       := $(PRODUCT_OUT)/obj/KERNEL_MODULES
NPROC                    := /usr/bin/nproc
XARGS                    := /usr/bin/xargs

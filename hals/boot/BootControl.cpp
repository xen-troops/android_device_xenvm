/*
 * Copyright (C) 2016 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#define LOG_TAG "android.hardware.boot@1.0-xenvm"

#include <log/log.h>
#include <utils/Log.h>
#include <cutils/properties.h>

#include <hardware/hardware.h>
#include <hardware/boot_control.h>
#include "BootControl.h"

#include <android-base/file.h>
#include <android-base/logging.h>
#include <android-base/properties.h>
#include <android-base/stringprintf.h>
#include <android-base/unique_fd.h>


#ifdef BOOT_CONTROL_RECOVERY
extern const hw_module_t HAL_MODULE_INFO_SYM;
#endif

namespace android {
namespace hardware {
namespace boot {
namespace V1_0 {
namespace implementation {

/*
 * Used CRC32 implementation from bootable/recovery/boot_control
 */

static uint32_t CRC32(const uint8_t* buf, size_t size) {
  static uint32_t crc_table[256];

  // Compute the CRC-32 table only once.
  if (!crc_table[1]) {
    for (uint32_t i = 0; i < 256; ++i) {
      uint32_t crc = i;
      for (uint32_t j = 0; j < 8; ++j) {
        uint32_t mask = -(crc & 1);
        crc = (crc >> 1) ^ (0xEDB88320 & mask);
      }
      crc_table[i] = crc;
    }
  }

  uint32_t ret = -1;
  for (size_t i = 0; i < size; ++i) {
    ret = (ret >> 8) ^ crc_table[(ret ^ buf[i]) & 0xFF];
  }

  return ~ret;
}


/* 
 * According to bootable/recovery/bootloader_message/include/bootloader_message/bootloader_message.h
 * Spaces used by misc partition are as below:
 * 0   - 2K     For bootloader_message
 * 2K  - 16K    Used by Vendor's bootloader (the 2K - 4K range may be optionally used
 *              as bootloader_message_ab struct)
 * 16K - 32K    Used by uncrypt and recovery to store wipe_package for A/B devices
 * 32K - 64K    System space, used for miscellanious AOSP features. See below.
 * Note that these offsets are admitted by bootloader,recovery and uncrypt, so they
 * are not configurable without changing all of them.
 * 
 */

void BootControl::setSlotUnbootable(slot_metadata* slotData) {
    slotData->priority = 0;
    slotData->tries_remaining = 0;
    slotData->successful_boot = 0;
};

bool BootControl::loadBootloaderControl(bootloader_control* bc) {
    android::base::unique_fd fd(open(kMiscPath, O_RDONLY));
    if (fd.get() == -1) {
        ALOGE("Failed to open '/mics' partition");
        return false;
    }
    if (lseek(fd, VENDOR_SPACE_OFFSET_IN_MISC, SEEK_SET)
            != VENDOR_SPACE_OFFSET_IN_MISC) {
        ALOGE("Failed to seek '/mics' partition");
        return false;
    }
    if (!android::base::ReadFully(fd.get(), bc, sizeof(bootloader_control))) {
        ALOGE("Failed to read '/mics' partition");
        return false;
    }

    /*if (!validateBootloaderControl(bc)) {
        return false;
    }*/
    return true;
};

bool BootControl::saveBootloaderControl(bootloader_control* bc) {
    bc->crc32_le = CRC32(reinterpret_cast<const uint8_t*>(bc), offsetof(bootloader_control, crc32_le));

    android::base::unique_fd fd(open(kMiscPath, O_WRONLY | O_SYNC));
    if (fd.get() == -1) {
        ALOGE("Failed to open %s partition", kMiscPath);
        return false;
    }
    if (lseek(fd.get(), VENDOR_SPACE_OFFSET_IN_MISC, SEEK_SET)
            != VENDOR_SPACE_OFFSET_IN_MISC) {
        ALOGE("Failed to seek %s partition", kMiscPath);
        return false;
    }
    if (!android::base::WriteFully(fd.get(), bc, sizeof(bootloader_control))) {
        ALOGE("Failed to write %s partition", kMiscPath);
        return false;
    }

    return true;
};

uint32_t BootControl::slotSuffixToIndex(const char* suffix) {
    for (uint32_t slot = 0; slot < kAvbMaxSlots; ++slot) {
        if (!strncmp(avbAbSlotsSuffixes[slot], suffix, 2)) {
            return slot;
        }
    }
    return AVB_AB_ERROR_SLOT_INDEX;
};

bool BootControl::checkSlotIsBootable(slot_metadata* slot_data) {
    return (slot_data->priority > 0)
            && (slot_data->successful_boot
                    || (slot_data->tries_remaining > 0));
}

BootControl::BootControl() {
    std::string suffix_prop = android::base::GetProperty(
            kAvbAbSlotSuffixProperty, "");
    mCurrentSlotIndex =  slotSuffixToIndex(suffix_prop.c_str());
    if (mCurrentSlotIndex == AVB_AB_ERROR_SLOT_INDEX) {
        ALOGE("Unable to to get correct AVB_AB slot index");
    }
}

// Methods from ::android::hardware::boot::V1_0::IBootControl follow.
Return<uint32_t> BootControl::getNumberSlots()  {
    return kAvbMaxSlots;
}

Return<uint32_t> BootControl::getCurrentSlot()  {
    return mCurrentSlotIndex;
}

Return<void> BootControl::markBootSuccessful(markBootSuccessful_cb _hidl_cb)  {
    int ret = -EIO;

    if (mCurrentSlotIndex != AVB_AB_ERROR_SLOT_INDEX) {
        bootloader_control abData;
        if (loadBootloaderControl (&abData)) {
            //if (checkSlotIsBootable(&abData.slots[mCurrentSlotIndex])) {
                abData.slot_info[mCurrentSlotIndex].successful_boot = 1;
                abData.slot_info[mCurrentSlotIndex].tries_remaining = AVB_AB_MAX_TRIES_REMAINING;
                if (saveBootloaderControl (&abData)) {
                    ret = 0;
                }
            //}
        }
    }
    //ret = 0 ;
    struct CommandResult cr;
    cr.success = (ret == 0);
    cr.errMsg = strerror(-ret);
    _hidl_cb(cr);
    return Void();
}

Return<void> BootControl::setActiveBootSlot(uint32_t slot, setActiveBootSlot_cb _hidl_cb)  {
    int ret = -EINVAL;
    if (slot < getNumberSlots()) {
        ret = -EIO;
        bootloader_control abData;
        if (loadBootloaderControl (&abData)) {
            /* Make requested slot top priority, unsuccessful,
             * and with max tries
             */
            abData.slot_info[slot].priority = AVB_AB_MAX_PRIORITY;
            abData.slot_info[slot].tries_remaining =
                    AVB_AB_MAX_TRIES_REMAINING;
            //abData.slot_info[slot].successful_boot = 0;

            /* Ensure other slot doesn't have as high a priority. */
            uint32_t other_slot = 1 - slot;
            if (abData.slot_info[other_slot].priority == AVB_AB_MAX_PRIORITY) {
                abData.slot_info[other_slot].priority = AVB_AB_MAX_PRIORITY - 1;
            }

            if (saveBootloaderControl (&abData)) {
                ret = 0;
            }
        }
    }
    struct CommandResult cr;
    cr.success = (ret == 0);
    cr.errMsg = strerror(-ret);
    _hidl_cb(cr);
    return Void();
}

Return<void> BootControl::setSlotAsUnbootable(uint32_t slot, setSlotAsUnbootable_cb _hidl_cb)  {
    int ret = -EINVAL;

    if (slot < getNumberSlots()) {
        ret = -EIO;
        bootloader_control abData;
        if (loadBootloaderControl (&abData)) {
            setSlotUnbootable(&abData.slot_info[slot]);
            if (saveBootloaderControl (&abData)) {
                ret = 0;
            }
        }
    }
    struct CommandResult cr;
    cr.success = (ret == 0);
    cr.errMsg = strerror(-ret);
    _hidl_cb(cr);
    return Void();
}

Return<BoolResult> BootControl::isSlotBootable(uint32_t slot)  {
    bootloader_control abData;
    if ((slot >= getNumberSlots()) || (!loadBootloaderControl (&abData))){
        return BoolResult::INVALID_SLOT;
    }

    /* Returns TRUE if the slot is bootable, FALSE if it's not */
    return checkSlotIsBootable(&abData.slot_info[slot]) ?
        BoolResult::TRUE : BoolResult::FALSE;
}

Return<BoolResult> BootControl::isSlotMarkedSuccessful(uint32_t slot)  {
    bootloader_control abData;

    if ((slot >= getNumberSlots()) || (!loadBootloaderControl (&abData))) {
        return BoolResult::INVALID_SLOT;
    }

    /* Returns TRUE if slot has been marked as successful, FALSE if it has not */
    return abData.slot_info[slot].successful_boot ? BoolResult::TRUE : BoolResult::FALSE;
}

Return<void> BootControl::getSuffix(uint32_t slot, getSuffix_cb _hidl_cb)  {
    /* Returns the empty string "" if slot does not match an existing slot */
    hidl_string ans("");

    if (slot < getNumberSlots()) {
        ans = avbAbSlotsSuffixes[slot];
    }

    _hidl_cb(ans);
    return Void();
}

#ifdef BOOT_CONTROL_RECOVERY
IBootControl* HIDL_FETCH_IBootControl(const char * /* hal */) {
    return new BootControl();
}
#else
IBootControl* HIDL_FETCH_IBootControl(const char* /* hal */) {
    return new BootControl();
}
#endif
} // namespace implementation
}  // namespace V1_0
}  // namespace boot
}  // namespace hardware
}  // namespace android

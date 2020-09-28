/*
 * Copyright 2018 The Android Open Source Project
 * Copyright 2020 EPAM Systems
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

#define LOG_TAG "android.hardware.graphics.allocator@3.0.xenvm"

#include "Allocator.h"
#include "GrallocLoader.h"

namespace android {
namespace hardware {
namespace graphics {
namespace allocator {
namespace V3_0 {
namespace xenvm {
namespace hal {
namespace detail {
template <>
Return<void> Allocator::allocate(const BufferDescriptor& descriptor, uint32_t count,
                          IAllocator::allocate_cb hidl_cb) {
    uint32_t stride;
    std::vector<const native_handle_t*> buffers;
    Error error = mHal->allocateBuffers(descriptor, count, &stride, &buffers);
    if (error != Error::NONE) {
        hidl_cb(error, 0, hidl_vec<hidl_handle>());
        return Void();
    }

    hidl_vec<hidl_handle> hidlBuffers(buffers.cbegin(), buffers.cend());
    hidl_cb(Error::NONE, stride, hidlBuffers);

    // free the local handles
    mHal->freeBuffers(buffers);

    return Void();
}

template <>
Return<void> Allocator::dumpDebugInfo(IAllocator::dumpDebugInfo_cb hidl_cb) {
        hidl_cb(mHal->dumpDebugInfo());
        return Void();
}

}  // namespace detail

extern "C" IAllocator* HIDL_FETCH_IAllocator(const char* /* name */) {
    return passthrough::GrallocLoader::load();
}

}  // namespace hal
}  // namespace xenvm
}  // namespace V3_0
}  // namespace allocator
}  // namespace graphics
}  // namespace hardware
}  // namespace android

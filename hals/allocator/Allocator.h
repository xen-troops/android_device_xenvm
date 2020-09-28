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

#pragma once

#ifndef LOG_TAG
#warning "Allocator.h included without LOG_TAG"
#endif

#include <memory>

#include "AllocatorHal.h"
#include <android/hardware/graphics/allocator/3.0/IAllocator.h>
#include <android/hardware/graphics/mapper/3.0/IMapper.h>
#include <log/log.h>

namespace android {
namespace hardware {
namespace graphics {
namespace allocator {
namespace V3_0 {

namespace xenvm {
namespace hal {

using mapper::V3_0::BufferDescriptor;
using mapper::V3_0::Error;

namespace detail {

// AllocatorImpl implements V3_*::IAllocator on top of V3_*::hal::AllocatorHal
template <typename Interface, typename Hal>
class AllocatorImpl : public Interface {
   public:
    bool init(std::unique_ptr<Hal> hal) {
        mHal = std::move(hal);
        return true;
    }

    Return<void> dumpDebugInfo(IAllocator::dumpDebugInfo_cb hidl_cb) override ;

    Return<void> allocate(const BufferDescriptor& descriptor, uint32_t count,
                          IAllocator::allocate_cb hidl_cb) override ;

   protected:
    std::unique_ptr<Hal> mHal;
};

}  // namespace detail

using Allocator = detail::AllocatorImpl<IAllocator, AllocatorHal>;

}  // namespace hal
}  // namespace xenvm
}  // namespace V3_0
}  // namespace allocator
}  // namespace graphics
}  // namespace hardware
}  // namespace android

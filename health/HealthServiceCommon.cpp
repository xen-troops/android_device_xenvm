/*
 * Copyright 2017 The Android Open Source Project
 * Copyright (C) 2019 EPAM Systems Inc.
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

#define LOG_TAG "android.hardware.health@2.0-service.xenvm"

#include <android-base/logging.h>

#include <android/hardware/health/1.0/types.h>
#include <hal_conversion.h>
#include <health2/service.h>
#include <healthd/healthd.h>
#include <hidl/HidlTransportSupport.h>
#include "Health.h"

using android::hardware::IPCThreadState;
using android::hardware::configureRpcThreadpool;
using android::hardware::handleTransportPoll;
using android::hardware::setupTransportPolling;
using android::hardware::health::V2_0::HealthInfo;
using android::hardware::health::V1_0::hal_conversion::convertToHealthInfo;
using android::hardware::health::V2_0::IHealth;
using android::hardware::health::V2_0::xenvm::Health;

extern int healthd_main(void);

static int gBinderFd = -1;
static std::string gInstanceName;

static void binder_event(uint32_t /*epevents*/) {
    if (gBinderFd >= 0) handleTransportPoll(gBinderFd);
}

void healthd_mode_service_2_0_init(struct healthd_config* config) {
    LOG(INFO) << LOG_TAG << gInstanceName << " Hal is starting up...";

    gBinderFd = setupTransportPolling();

    if (gBinderFd >= 0) {
        if (healthd_register_event(gBinderFd, binder_event))
            LOG(ERROR) << LOG_TAG << gInstanceName << ": Register for binder events failed";
    }

    android::sp<IHealth> service = Health::initInstance(config);
    CHECK_EQ(service->registerAsService(gInstanceName), android::OK)
        << LOG_TAG << gInstanceName << ": Failed to register HAL";

    LOG(INFO) << LOG_TAG << gInstanceName << ": Hal init done";
}

int healthd_mode_service_2_0_preparetowait(void) {
    IPCThreadState::self()->flushCommands();
    return -1;
}

void healthd_mode_service_2_0_heartbeat(void) {
}

void healthd_mode_service_2_0_battery_update(struct android::BatteryProperties* prop) {
    HealthInfo info;
    convertToHealthInfo(prop, info.legacy);
    Health::getImplementation()->notifyListeners(&info);
}

static struct healthd_mode_ops healthd_mode_service_2_0_ops = {
    .init = healthd_mode_service_2_0_init,
    .preparetowait = healthd_mode_service_2_0_preparetowait,
    .heartbeat = healthd_mode_service_2_0_heartbeat,
    .battery_update = healthd_mode_service_2_0_battery_update,
};

void healthd_board_init(struct healthd_config*) {}
void get_storage_info(std::vector<struct StorageInfo>&) {}
void get_disk_stats(std::vector<struct DiskStats>&) {}

int healthd_board_battery_update(struct android::BatteryProperties*) {
    return 0;
}

int main()
{
    if (gInstanceName.empty()) {
        gInstanceName = "default";
    }
    healthd_mode_ops = &healthd_mode_service_2_0_ops;
    LOG(INFO) << LOG_TAG << gInstanceName << ": Hal starting main loop...";
    return healthd_main();
}

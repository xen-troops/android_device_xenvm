#
# Copyright (C) 2019 The Android Open-Source Project
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

# Base platform for car builds
# car packages should be added to car.mk instead of here

PRODUCT_PACKAGES += \
    com.android.wifi \
    BasicDreams \
    CaptivePortalLogin \
    CertInstaller \
    DocumentsUI \
    DownloadProviderUi \
    FusedLocation \
    InputDevices \
    KeyChain \
    Keyguard \
    LatinIME \
    Launcher2 \
    ManagedProvisioning \
    PacProcessor \
    PrintSpooler \
    ProxyHandler \
    Settings \
    SharedStorageBackup \
    VpnDialogs \
    MmsService \
    ExternalStorageProvider \
    StorageManager \
    Calendar \
    CalendarProvider \
    DeskClock \
    QuickSearchBox \
    atrace \
    libandroidfw \
    libaudioutils \
    libmdnssd \
    libnfc_ndef \
    libpowermanager \
    libspeexresampler \
    libvariablespeed \
    libwebrtc_audio_preprocessing \
    A2dpSinkService \
    PackageInstaller \
    car-bugreportd \

# EVS resources
PRODUCT_PACKAGES += android.automotive.evs.manager@1.0

# Device running Android is a car
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.type.automotive.xml:system/etc/permissions/android.hardware.type.automotive.xml

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_minimal.mk)

# Default dex optimization configurations
PRODUCT_PROPERTY_OVERRIDES += \
    pm.dexopt.disable_bg_dexopt=true

# Enable car watchdog
include packages/services/Car/watchdog/product/carwatchdog.mk

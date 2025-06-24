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
#

$(call inherit-product-if-exists, external/hyphenation-patterns/patterns.mk)
$(call inherit-product-if-exists, external/noto-fonts/fonts.mk)
$(call inherit-product-if-exists, external/roboto-fonts/fonts.mk)
$(call inherit-product-if-exists, frameworks/base/data/keyboards/keyboards.mk)
$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)

$(call inherit-product, build/target/product/core_64_bit_only.mk)
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)
$(call inherit-product, device/xen/xenvm/build/common_build.mk)

PRODUCT_SHIPPING_API_LEVEL := 33
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false
PRODUCT_USE_VNDK := true
PRODUCT_FULL_TREBLE := true
PRODUCT_ENFORCE_VINTF_MANIFEST := true

PRODUCT_PACKAGES += vndservicemanager

# Boot control HAL (libavb)
PRODUCT_PACKAGES +=  \
    android.hardware.boot@1.1-impl \
    android.hardware.boot@1.1-service

# A/B System Updates
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := \
    boot \
    init_boot \
    vendor_boot \
    system \
    vendor \
    vbmeta \

PRODUCT_USE_DYNAMIC_PARTITIONS := true

PRODUCT_PACKAGES += \
    update_verifier \
    update_engine

# A/B OTA dexopt package
PRODUCT_PACKAGES += \
    otapreopt_script

# Add preffered configurations
PRODUCT_AAPT_CONFIG := normal large xlarge hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

# Used for post install functionality
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.xenvm-postinstall-done=0

# The default locale should be determined from VPD, not from build.prop.
PRODUCT_SYSTEM_PROPERTY_BLACKLIST := ro.product.locale

# Configure ADB for network connections
PRODUCT_PROPERTY_OVERRIDES += service.adb.tcp.port=5555

# VISS
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.vis.uri="wss://wwwivi:443"

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196609 \
    ro.radio.noril=true \
    ro.carrier=unknown \

PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=160

PRODUCT_TAGS += dalvik.gc.type-precise


# Software permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.activities_on_secondary_displays.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.activities_on_secondary_displays.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.autofill.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.autofill.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.software.connectionservice.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.connectionservice.xml \
    frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml \
    frameworks/native/data/etc/android.software.freeform_window_management.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.freeform_window_management.xml \
    frameworks/native/data/etc/android.software.managed_users.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.managed_users.xml \
    frameworks/native/data/etc/android.software.picture_in_picture.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.picture_in_picture.xml \
    frameworks/native/data/etc/android.software.secure_lock_screen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.secure_lock_screen.xml \
    frameworks/native/data/etc/android.software.voice_recognizers.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.voice_recognizers.xml \
    frameworks/native/data/etc/android.software.webview.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.webview.xml \

# Hardware permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/car_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/car_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.location.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.screen.landscape.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.landscape.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.type.automotive.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.type.automotive.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \


# Copy car_core_hardware and overwrite handheld_core_hardware.xml with a disable config.
# Overwrite goldfish related xml with a disable config.
PRODUCT_COPY_FILES += \
    device/generic/car/common/android.hardware.disable.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
    device/generic/car/common/car_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/car_core_hardware.xml \
    device/generic/car/common/android.hardware.disable.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.ar.xml \
    device/generic/car/common/android.hardware.disable.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.autofocus.xml \
    device/generic/car/common/android.hardware.disable.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    device/generic/car/common/android.hardware.disable.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    device/generic/car/common/android.hardware.disable.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    device/generic/car/common/android.hardware.disable.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.any.xml \
    device/generic/car/common/android.hardware.disable.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    device/generic/car/common/android.hardware.disable.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    device/generic/car/common/android.hardware.disable.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    device/generic/car/common/android.hardware.disable.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \

# Permission for Wi-Fi passpoint support
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml

# Additional permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.broadcastradio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.broadcastradio.xml \
    frameworks/native/data/etc/android.hardware.type.automotive.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.type.automotive.xml \


# DRM HAL
#$(call inherit-product, hardware/interfaces/drm/1.0/default/common_default_service.mk)

# Init rc
PRODUCT_COPY_FILES +=\
    device/xen/xenvm/init.xenvm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.xenvm.rc \
    device/xen/xenvm/init.xenvm.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.xenvm.usb.rc \
    device/xen/xenvm/ueventd.xenvm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    packages/services/Car/car_product/init/init.car.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.car.rc \
    packages/services/Car/car_product/init/init.bootstat.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.bootstat.rc

# Mount points
ifneq ($(DISABLE_AVB),true)
  PRODUCT_COPY_FILES += \
    device/xen/xenvm/fstab.xenvm.avb:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.xenvm \
    device/xen/xenvm/fstab.xenvm.avb:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.xenvm \
    device/xen/xenvm/fstab.xenvm.avb:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/fstab.xenvm \

TARGET_RECOVERY_FSTAB := device/xen/xenvm/fstab.xenvm.avb
else
  PRODUCT_COPY_FILES += \
    device/xen/xenvm/fstab.xenvm:root/fstab.xenvm \
    device/xen/xenvm/fstab.xenvm:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.xenvm \
    device/xen/xenvm/fstab.xenvm:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.xenvm \

TARGET_RECOVERY_FSTAB := device/xen/xenvm/fstab.xenvm
endif

# Software multimedia
PRODUCT_PACKAGES += \
    stagefright \
    libstagefrighthw \
    libsfplugin_ccodec \
    libstagefright_bufferqueue_helper \
    android.hardware.media.c2@1.0 \
    libstagefright_bufferpool@2.0 \
    com.android.media.swcodec-defaults \
    com.android.media.swcodec \

# media codec config xml file
PRODUCT_COPY_FILES += \
    device/xen/xenvm/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    device/xen/xenvm/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# audio config xml file
PRODUCT_COPY_FILES += \
    device/xen/xenvm/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    device/xen/xenvm/car_audio_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/car_audio_configuration.xml \
    device/xen/xenvm/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \

PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.0-impl

# seccomp policy
PRODUCT_PACKAGES += \
    mediacodec.policy \
    crash_dump.policy

# All VNDK libraries (HAL interfaces, VNDK, VNDK-SP, LL-NDK)
PRODUCT_PACKAGES += vndk_package

# Boot animation
PRODUCT_COPY_FILES += \
    device/xen/xenvm/bootanimation/bootanimation.zip:system/media/bootanimation.zip

# Input mapping
PRODUCT_COPY_FILES += \
    device/xen/xenvm/input-port-associations.xml:$(TARGET_COPY_OUT_VENDOR)/etc/input-port-associations.xml

# Native apps for audio
PRODUCT_PACKAGES += \
    tinyplay \
    tinycap \
    tinymix

PRODUCT_PACKAGES += \
    librs_jni \

# Composer 2.3
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.3-hal \
    android.hardware.graphics.composer@2.3-passthrough \
    android.hardware.graphics.composer@2.3-service \

# DRM Composer
PRODUCT_VENDOR_PROPERTIES += vendor.hwc.backend_override=client
PRODUCT_PACKAGES += \
    hwcomposer.$(TARGET_PRODUCT) \

# Modetest from libdrm
PRODUCT_PACKAGES += \
    modetest \

PRODUCT_PACKAGES += \
    android.hardware.health@2.1-service \
    android.hardware.health@2.1-impl \
    android.hardware.health.storage@1.0-service \

# Generic Vehicle HAL
PRODUCT_PACKAGES += \
    android.hardware.automotive.vehicle@2.0-default-service

# Wi-Fi
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    hostapd \
    wlutil \
    wificond \
    wifilogd \
    wpa_supplicant

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.1-service.btlinux \
    android.hardware.bluetooth.audio@2.1-impl \

PRODUCT_COPY_FILES += \
    device/xen/xenvm/bluetooth/firmware/rtl8761b_fw.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/rtl_bt/rtl8761b_fw.bin \
    device/xen/xenvm/bluetooth/firmware/rtl8761b_config.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/rtl_bt/rtl8761b_config.bin \

# Set default log size on userdebug/eng builds to 2M
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PROPERTY_OVERRIDES += ro.logd.size=10M
endif

# Gallery and Music for local AV playback
PRODUCT_PACKAGES += \
    Gallery2 \
    Music \

# Web browser
PRODUCT_PACKAGES += \
    Browser2 \

# App for graphics testing
PRODUCT_PACKAGES += \
    glmark2

ifneq ($(TARGET_PREBUILT_KERNEL),)
PRODUCT_COPY_FILES +=   $(TARGET_PREBUILT_KERNEL):kernel
endif

# Recovery files
PRODUCT_COPY_FILES += \
    device/xen/xenvm/init.recovery.xenvm.rc:root/init.recovery.xenvm.rc

# Multimedia
PRODUCT_COPY_FILES += \
    device/xen/xenvm/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/xen/xenvm/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy \
    device/xen/xenvm/seccomp/mediaswcodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaswcodec.policy

# Wifi
PRODUCT_PACKAGES += \
    libwpa_client \
    libwifilogd \
    p2p_supplicant.conf

PRODUCT_PROPERTY_OVERRIDES += \
    wifi.direct.interface=p2p0 \
    wifi.interface=wlan0

PRODUCT_COPY_FILES += \
    frameworks/av/media/libeffects/data/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.conf

PRODUCT_COPY_FILES += \
    device/generic/car/emulator/cluster/display_settings.xml:system/etc/display_settings.xml

PRODUCT_VENDOR_PROPERTIES += \
    ro.setupwizard.mode?=OPTIONAL

# Recovery packages
PRODUCT_PACKAGES += \
        linker.recovery \
        shell_and_utilities_recovery \
        adbd.recovery \


# Img deps
PRODUCT_PACKAGES += \
    libdmabufinfo \
    libprotobuf-cpp-lite \
    libaidlcommonsupport \
    perfetto_trace_protos \
    libperfetto_client_experimental \
    android.hardware.atrace@1.0.vendor \
    android.hardware.dumpstate@1.0.vendor \
    android.hardware.thermal@2.0.vendor \
    android.hardware.thermal@1.0.vendor \
    libdrm \

PRODUCT_PACKAGES += \
    audio.usb.default \
    audio.usbv2.default

# Sw GK KM
# Keymaster HAL
# All security related settings are moved into dedicated security.mk
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.0-service \
    android.hardware.keymaster@4.0-impl \
    android.hardware.gatekeeper@1.0-service.software \

PRODUCT_PACKAGES += \
    android.hardware.audio.sounddose-vendor-impl \
    audio_sounddose_aoc

# Graphics allocator/mapper HIDL HALs
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.mapper@2.0-impl-2.1

# Graphics allocator AIDL V1 HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-V1-ndk.vendor

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0.vndk-sp \
    android.hardware.graphics.mapper@2.0.vndk-sp \
    android.hardware.graphics.mapper@2.1.vndk-sp \
    android.hardware.graphics.common@1.0.vndk-sp \
    android.hardware.atrace@1.0.vndk-sp \
    libhwbinder.vndk-sp \
    libbase.vndk-sp \
    libcutils.vndk-sp \
    libhardware.vndk-sp \
    libhidlbase.vndk-sp \
    libhidltransport.vndk-sp \
    libutils.vndk-sp \
    libc++.vndk-sp \
    libRS_internal.vndk-sp \
    libRSDriver.vndk-sp \
    libRSCpuRef.vndk-sp \
    libbcinfo.vndk-sp \
    libblas.vndk-sp \
    libft2.vndk-sp \
    libpng.vndk-sp \
    libcompiler_rt.vndk-sp \
    libbacktrace.vndk-sp \
    libunwind.vndk-sp \
    libunwindstack.vndk-sp \
    liblzma.vndk-sp \
    libion.vndk-sp \
    android.hardware.graphics.composer@2.1 \

# Graphics composer HIDL HAL (service added below)
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.1.vendor \
    android.hardware.graphics.composer@2.1-impl

# Health service
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

# Dumpstate
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.1 \
    android.hardware.dumpstate@1.1.vendor


# Enable Storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Virtual AB
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)

# Required for media APEX
PRODUCT_PACKAGES += \
    updatable-media

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.audio.primary=caremu-ext \
    ro.vendor.caremu.audiohal.out_period_ms=16 \
    ro.vendor.caremu.audiohal.in_period_ms=16

# Enable audio source for USB Audio
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=audio_source,adb

# Car Emulator Audio HAL
PRODUCT_PACKAGES += \
    audio.primary.caremu \
    audio.r_submix.default \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.audio.service \
    audio.primary.caremu-ext \
    audio.r_submix.default \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.audio.service \

# EVS Camera HAL
PRODUCT_PACKAGES += \
    android.hardware.automotive.evs-xt \
    evs_app-xt \
    evsmanagerd-xt \

ENABLE_EVS_SAMPLE := true
ENABLE_EVS_SERVICE := true

# Updateble APEX
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

PRODUCT_PACKAGE_OVERLAYS += device/xen/xenvm/overlay

$(call inherit-product, build/make/target/product/generic_ramdisk.mk)
$(call inherit-product, packages/services/Car/car_product/build/car.mk)
$(call inherit-product, device/xen/xenvm/build/graphics.mk)
$(call inherit-product-if-exists, frameworks/base/data/sounds/AudioPackage13.mk)
$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
$(call inherit-product, device/xen/xenvm/build/kernel_modules.mk)
$(call inherit-product-if-exists, vendor/epam/aosp-hmi/epam-automotive-launcher.mk)
$(call inherit-product-if-exists, vendor/epam/EpamSystemUI/epam-systemui.mk)
$(call inherit-product-if-exists, vendor/epam/EpamMusic/epam-audio.mk)

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
    device/xen/xenvm/init.xenvm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.xenvm.rc \
    device/xen/xenvm/init.xenvm.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.xenvm.usb.rc \
    device/xen/xenvm/ueventd.xenvm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    packages/services/Car/car_product/init/init.car.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.car.rc \
    packages/services/Car/car_product/init/init.bootstat.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.bootstat.rc

# Mount points
ifneq ($(DISABLE_AVB),true)
  PRODUCT_COPY_FILES += \
    device/xen/xenvm/fstab.xenvm.avb:root/fstab.xenvm \
    device/xen/xenvm/fstab.xenvm.avb:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.xenvm \
    device/xen/xenvm/fstab.xenvm.avb:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.xenvm \

TARGET_RECOVERY_FSTAB := device/xen/xenvm/fstab.xenvm.avb
else
  PRODUCT_COPY_FILES += \
    device/xen/xenvm/fstab.xenvm:root/fstab.xenvm \
    device/xen/xenvm/fstab.xenvm:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.xenvm \
    device/xen/xenvm/fstab.xenvm:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.xenvm \

TARGET_RECOVERY_FSTAB := device/xen/xenvm/fstab.xenvm
endif


# media codec config xml file
#PRODUCT_COPY_FILES += \
#    device/xen/xenvm/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
#    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
#    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
#    device/xen/xenvm/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# Software multimedia
#PRODUCT_PACKAGES += \
#    stagefright \
#    libstagefrighthw \
#    libsfplugin_ccodec \
#    libstagefright_bufferqueue_helper \
#    android.hardware.media.c2@1.0 \
#    libstagefright_bufferpool@2.0 \


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

# Composer 2.1
#PRODUCT_PACKAGES += \
#    android.hardware.graphics.composer@2.1-impl \
#    android.hardware.graphics.composer@2.1-service \

# DRM Composer
PRODUCT_VENDOR_PROPERTIES += vendor.hwc.backend_override=client
PRODUCT_PACKAGES += \
    hwcomposer.$(TARGET_PRODUCT) \

# Modetest from libdrm
PRODUCT_PACKAGES += \
    modetest \

# Health HAL 2.0
#PRODUCT_PACKAGES += \
#    android.hardware.health@2.0-service.xenvm \

PRODUCT_PACKAGES += \
    android.hardware.health@2.1-service \
    android.hardware.health@2.1-impl \
    android.hardware.health.storage@1.0-service \

# Keymaster HAL
# All security related settings are moved into dedicated security.mk

# EPAM VISS Vehicle HAL
PRODUCT_PACKAGES += \
    epam_android.hardware.automotive.vehicle@2.0-service \

# Generic memtrack module
PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service

# Wi-Fi
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    hostapd \
    wlutil \
    wificond \
    wifilogd \
    wpa_supplicant

# GNSS
PRODUCT_PACKAGES += \
    android.hardware.gnss@1.1-service.xenvm \
    libuws \

#Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-service.xenvm \

PRODUCT_COPY_FILES += \
    vendor/xen/sensors/cfg/sensors-config.json:$(TARGET_COPY_OUT_VENDOR)/etc/vehicle/sensors-config.json

# Exterior View System (EVS)
ifeq ($(ANDROID_EVS_ENABLED),true)
$(call inherit-product, vendor/xen/evs/evs.mk)
endif

# Bluetooth
PRODUCT_PACKAGES += android.hardware.bluetooth@1.1-service.btlinux
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \


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

# C2 HAL
PRODUCT_PACKAGES += \
    android.hardware.media.c2@1.0-service.renesas \
    stagefright

# Wifi
PRODUCT_PACKAGES += \
    libwpa_client \
    libwifilogd \
    p2p_supplicant.conf

PRODUCT_PROPERTY_OVERRIDES += \
    wifi.direct.interface=p2p0 \
    wifi.interface=wlan0



# Audio common defaults
$(call inherit-product, vendor/renesas/hal/audio/car_audio.mk)

PRODUCT_COPY_FILES += \
    frameworks/av/media/libeffects/data/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.conf


# Cluster deps
DEVICE_PACKAGE_OVERLAYS += device/generic/car/emulator/cluster/osdouble_overlay

PRODUCT_COPY_FILES += \
    device/generic/car/emulator/cluster/display_settings.xml:system/etc/display_settings.xml

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.setupwizard.mode?=OPTIONAL


# Enable Storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Virtual AB
$(call inherit-product, \
    $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

PRODUCT_PACKAGE_OVERLAYS += device/xen/xenvm/overlay

# Cluster rro
PRODUCT_PACKAGES += CarServiceOverlayEmulatorOsDouble
PRODUCT_PACKAGES += CarServiceOverlayEmulatorOsDoubleEpam

$(call inherit-product, packages/services/Car/car_product/build/car.mk)
$(call inherit-product, device/xen/xenvm/build/graphics.mk)
$(call inherit-product-if-exists, frameworks/base/data/sounds/AudioPackage13.mk)
$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
$(call inherit-product, device/xen/xenvm/build/security.mk)
$(call inherit-product, device/xen/xenvm/build/kernel_modules.mk)
$(call inherit-product, vendor/epam/aosp-hmi/epam-automotive-launcher.mk)
$(call inherit-product, vendor/epam/ces-navigation/epam-navigation.mk)
$(call inherit-product, vendor/epam/EpamCluster/epam-cluster-product.mk)
$(call inherit-product, vendor/epam/EpamMusic/epam-audio.mk)
$(call inherit-product, vendor/epam/epam-hnav-dist/epam-hnav.mk)
$(call inherit-product, vendor/epam/EpamSystemUI/epam-systemui.mk)


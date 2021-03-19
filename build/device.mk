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

$(call inherit-product, build/target/product/core_64_bit.mk)
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)
$(call inherit-product, packages/services/Car/car_product/build/car.mk)
$(call inherit-product, device/xen/xenvm/build/common_build.mk)

PRODUCT_SHIPPING_API_LEVEL := 30
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

# The default locale should be determined from VPD, not from build.prop.
PRODUCT_SYSTEM_PROPERTY_BLACKLIST := ro.product.locale

# Configure ADB for network connections
PRODUCT_PROPERTY_OVERRIDES += service.adb.tcp.port=5555


PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196609 \
    ro.radio.noril=true \
    ro.carrier=unknown \
    persist.vehicle.use-vis-hal=false \

# Define audio tracks that we want to use as default.
# Do not change method of assignment because new values have to be prepended
# and not appended (do not use +=). Explanation from google's groups:
# "For PRODUCT_PROPERTY_OVERRIDES ... the first instance takes precedence."
# For same reason this override has to be used after include of car.mk
# in order to use our values.
PRODUCT_PROPERTY_OVERRIDES := \
     ro.config.ringtone=Atria.ogg \
     ro.config.notification_sound=Tethys.ogg \
     ro.config.alarm_alert=Oxygen.ogg \
     $(PRODUCT_PROPERTY_OVERRIDES)

PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=160

PRODUCT_TAGS += dalvik.gc.type-precise

# Use audio_policy_configuration.xml
USE_XML_AUDIO_POLICY_CONF := 1

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

# DRM HAL
$(call inherit-product, hardware/interfaces/drm/1.0/default/common_default_service.mk)

# Init rc
PRODUCT_COPY_FILES +=\
    device/xen/xenvm/init.xenvm.rc:root/init.xenvm.rc \
    device/xen/xenvm/ueventd.xenvm.rc:root/ueventd.xenvm.rc \
    packages/services/Car/car_product/init/init.car.rc:root/init.car.rc \
    packages/services/Car/car_product/init/init.bootstat.rc:root/init.bootstat.rc

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

PRODUCT_COPY_FILES += \
    device/xen/xenvm/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    device/xen/xenvm/car_audio_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/car_audio_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    device/xen/xenvm/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml


# media codec config xml file
PRODUCT_COPY_FILES += \
    device/xen/xenvm/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    device/xen/xenvm/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

PRODUCT_PACKAGES += \
    stagefright \
    libstagefrighthw \
    libsfplugin_ccodec \
    libstagefright_bufferqueue_helper \
    android.hardware.media.c2@1.0 \
    libstagefright_bufferpool@2.0 \


# seccomp policy
PRODUCT_PACKAGES += \
    mediacodec.policy \
    crash_dump.policy

# All VNDK libraries (HAL interfaces, VNDK, VNDK-SP, LL-NDK)
PRODUCT_PACKAGES += vndk_package

# Boot animation
PRODUCT_COPY_FILES += \
    packages/services/Car/car_product/bootanimations/bootanimation-832.zip:system/media/bootanimation.zip

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

# Config store HAL
PRODUCT_PACKAGES += \
    android.hardware.configstore@1.1-service

# Audio
PRODUCT_PACKAGES += \
    audio.primary.xenvm \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.audio@2.0-service

# AudioControl
PRODUCT_PACKAGES += \
    android.hardware.automotive.audiocontrol@1.0-service \

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

# Vehicle HAL
PRODUCT_PACKAGES += \
    android.hardware.automotive.vehicle-V2.0-java \
    android.hardware.automotive.vehicle@2.0-service.xenvm \

PRODUCT_COPY_FILES += \
    vendor/xen/vehicle/cfg/vehicle-mappings.json:$(TARGET_COPY_OUT_VENDOR)/etc/vehicle/vehicle-mappings.json

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
PRODUCT_PACKAGES += \
    android.frameworks.automotive.display@1.0-service \
    android.hardware.automotive.evs@1.1.xt \
    android.automotive.evs.manager@1.1 \
    evs_app_xt \

# Set default log size on userdebug/eng builds to 2M
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PROPERTY_OVERRIDES += ro.logd.size=2M
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

# Enable Storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Virtual AB
$(call inherit-product, \
    $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

$(call inherit-product, device/xen/xenvm/build/graphics.mk)
$(call inherit-product-if-exists, frameworks/base/data/sounds/AudioPackage13.mk)
$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
ifeq ($(USE_G_APPS),true)
$(call inherit-product-if-exists, vendor/Google/Google-product.mk)
endif
$(call inherit-product, device/xen/xenvm/build/security.mk)
$(call inherit-product, device/xen/xenvm/build/kernel_modules.mk)


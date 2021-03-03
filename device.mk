#
# Copyright (C) 2016 The Android Open-Source Project
# Copyright (C) 2018 EPAM Systems Inc.
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

# VISS
PRODUCT_PROPERTY_OVERRIDES += persist.vis.uri="wss://wwwivi:443"

# Add preffered configurations
PRODUCT_AAPT_CONFIG := normal large xlarge hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

# The default locale should be determined from VPD, not from build.prop.
PRODUCT_SYSTEM_PROPERTY_BLACKLIST := ro.product.locale

# Use Sdcardfs
PRODUCT_PROPERTY_OVERRIDES += ro.sys.sdcardfs=1

# Configure ADB for network connections
PRODUCT_PROPERTY_OVERRIDES += service.adb.tcp.port=5555

# Identify device as low RAM
PRODUCT_PROPERTY_OVERRIDES += ro.config.low_ram=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196609 \
    ro.radio.noril=true \
    ro.carrier=unknown

PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=160

PRODUCT_TAGS += dalvik.gc.type-precise

# Use audio_policy_configuration.xml
USE_XML_AUDIO_POLICY_CONF := 1

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.freeform_window_management.xml:system/etc/permissions/android.software.freeform_window_management.xml \
    frameworks/native/data/etc/android.software.backup.xml:system/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.software.webview.xml:system/etc/permissions/android.software.webview.xml \
    frameworks/native/data/etc/android.software.device_admin.xml:system/etc/permissions/android.software.device_admin.xml \
    frameworks/native/data/etc/android.software.managed_users.xml:system/etc/permissions/android.software.managed_users.xml \
    frameworks/native/data/etc/android.software.activities_on_secondary_displays.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.activities_on_secondary_displays.xml \
    frameworks/native/data/etc/android.software.connectionservice.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.connectionservice.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/car_core_hardware.xml:system/etc/permissions/car_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.type.automotive.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.type.automotive.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.screen.landscape.xml:system/etc/permissions/android.hardware.screen.landscape.xml \
    frameworks/native/data/etc/android.hardware.location.xml:system/etc/permissions/android.hardware.location.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.software.activities_on_secondary_displays.xml:system/etc/permissions/android.software.activities_on_secondary_displays.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.software.secure_lock_screen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.secure_lock_screen.xml \
    frameworks/native/data/etc/android.software.picture_in_picture.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.picture_in_picture.xml \
    frameworks/native/data/etc/android.software.autofill.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.autofill.xml \
    frameworks/native/data/etc/android.software.voice_recognizers.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.voice_recognizers.xml \







# Manifest
PRODUCT_COPY_FILES += \
    device/xen/xenvm/manifest.xml:$(TARGET_COPY_OUT_VENDOR)/manifest.xml

# Init rc
PRODUCT_COPY_FILES +=\
    device/xen/xenvm/init.xenvm.rc:root/init.xenvm.rc \
    device/xen/xenvm/ueventd.xenvm.rc:root/ueventd.xenvm.rc \
    packages/services/Car/car_product/init/init.car.rc:root/init.car.rc \
    packages/services/Car/car_product/init/init.bootstat.rc:root/init.bootstat.rc

# Mount points
ifeq ($(ENABLE_AVB),true)
  PRODUCT_COPY_FILES += \
    device/xen/xenvm/fstab.xenvm.avb:root/fstab.xenvm
else
  PRODUCT_COPY_FILES += \
    device/xen/xenvm/fstab.xenvm:root/fstab.xenvm
endif
PRODUCT_COPY_FILES += \
    device/xen/xenvm/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    device/xen/xenvm/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml


# media codec config xml file
PRODUCT_COPY_FILES += \
    device/xen/xenvm/media_codecs.xml:system/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml

PRODUCT_PACKAGES += \
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

# Input configuration
PRODUCT_COPY_FILES += \
    device/xen/xenvm/Vendor_5853_Product_fffd.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Vendor_5853_Product_fffd.idc \

# Native apps for audio
PRODUCT_PACKAGES += \
    tinyplay \
    tinycap \
    tinymix

PRODUCT_PACKAGES += \
    librs_jni \

# Config store HAL
PRODUCT_PACKAGES += \
    android.hardware.configstore@1.0-impl

# Audio
PRODUCT_PACKAGES += \
	audio.primary.xenvm \
    android.hardware.audio@4.0-impl \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.audio@2.0-service

# AudioControl
PRODUCT_PACKAGES += \
    android.hardware.automotive.audiocontrol@1.0-service \

# Composer
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    hwcomposer.$(TARGET_BOARD_PLATFORM) \

# Health HAL 2.0
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-service.xenvm \

# Keymaster HAL
# All security related settings are moved into dedicated security.mk
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \


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
#PRODUCT_PACKAGES += \
#    android.hardware.automotive.evs@1.0-service \
#    android.hardware.automotive.evs@1.0.xenvm \
#    android.automotive.evs.manager@1.0.xenvm \
#    evs_app_xt \

#PRODUCT_COPY_FILES += \
#    vendor/xen/evs/app/evs_app_xt.json:$(TARGET_COPY_OUT_VENDOR)/etc/vehicle/evs_app_xt.json

# Set default log size on userdebug/eng builds to 2M
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PROPERTY_OVERRIDES += ro.logd.size=2M
endif

# Gallery and Music for local AV playback
PRODUCT_PACKAGES += \
     Gallery2 \
     Music \

ifneq ($(TARGET_PREBUILT_KERNEL),)
PRODUCT_COPY_FILES +=   $(TARGET_PREBUILT_KERNEL):kernel
endif

DEVICE_PACKAGE_OVERLAYS := device/xen/xenvm/overlay

$(call inherit-product, device/xen/xenvm/graphics.mk)
$(call inherit-product-if-exists, frameworks/base/data/sounds/AudioPackage13.mk)
$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
ifeq ($(USE_G_APPS),true)
$(call inherit-product-if-exists, vendor/Google/Google-product.mk)
endif
#$(call inherit-product, device/xen/xenvm/security.mk)

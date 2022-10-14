#
# Copyright (C) 2018 The Android Open-Source Project
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

PRODUCT_PUBLIC_SEPOLICY_DIRS += packages/services/Car/car_product/sepolicy/public
PRODUCT_PRIVATE_SEPOLICY_DIRS += packages/services/Car/car_product/sepolicy/private

PRODUCT_IS_AUTOMOTIVE := true

PRODUCT_PACKAGES += \
    Bluetooth \
    CarDeveloperOptions \
    CompanionDeviceSupport \
    OneTimeInitializer \
    Provision \
    SystemUpdater \
    Browser2 \
    Gallery2 \
    Music \
    UserDictionaryProvider

PRODUCT_PACKAGES += \
    clatd \
    clatd.conf \
    pppd \
    screenrecord

# ActivityViewDemo
PRODUCT_PACKAGES += \
    ActivityViewDemo

# This is for testing
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PACKAGES += \
    DefaultStorageMonitoringCompanionApp \
    EmbeddedKitchenSinkApp \
    GarageModeTestApp

# SEPolicy for test apps / services
BOARD_SEPOLICY_DIRS += packages/services/Car/car_product/sepolicy/test
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.carrier=unknown

PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.enablenewavrcp=false \
    ro.fw.mu.headless_system_user=true

$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/dancing-script/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/carrois-gothic-sc/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/coming-soon/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/cutive-mono/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/source-sans-pro/fonts.mk)
$(call inherit-product-if-exists, external/noto-fonts/fonts.mk)
$(call inherit-product-if-exists, external/roboto-fonts/fonts.mk)
$(call inherit-product-if-exists, external/hyphenation-patterns/patterns.mk)
$(call inherit-product-if-exists, frameworks/base/data/keyboards/keyboards.mk)
$(call inherit-product-if-exists, frameworks/webview/chromium/chromium.mk)
$(call inherit-product, device/sample/products/location_overlay.mk)
$(call inherit-product, packages/services/Car/car_product/build/car_base.mk)

# Overrides
PRODUCT_PROPERTY_OVERRIDES := \
    ro.config.ringtone=Cygnus.ogg \
    ro.config.notification_sound=Aldebaran.ogg \
    ro.config.alarm_alert=Alarm_Classic.ogg \
    $(PRODUCT_PROPERTY_OVERRIDES)

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true

# Automotive specific packages
PRODUCT_PACKAGES += \
    CarFrameworkPackageStubs \
    CarService \
    CarDialerApp \
    CarRadioApp \
    OverviewApp \
    CarSystemUI \
    LocalMediaPlayer \
    CarMediaApp \
    CarMessengerApp \
    CarHvacApp \
    CarMapsPlaceholder \
    CarLatinIME \
    CarSettings \
    CarUsbHandler \
    android.car \
    car-frameworks-service \
    com.android.car.procfsinspector \
    libcar-framework-service-jni \

# System Server components
PRODUCT_SYSTEM_SERVER_JARS += car-frameworks-service

PRODUCT_COPY_FILES += \
    packages/services/Car/car_product/init/init.car.rc:system/etc/init/init.car.rc

PRODUCT_LOCALES := en_US af_ZA am_ET ar_EG bg_BG bn_BD ca_ES cs_CZ da_DK de_DE el_GR en_AU en_GB en_IN es_ES es_US et_EE eu_ES fa_IR fi_FI fr_CA fr_FR gl_ES hi_IN hr_HR hu_HU hy_AM in_ID is_IS it_IT iw_IL ja_JP ka_GE km_KH ko_KR ky_KG lo_LA lt_LT lv_LV km_MH kn_IN mn_MN ml_IN mk_MK mr_IN ms_MY my_MM ne_NP nb_NO nl_NL pl_PL pt_BR pt_PT ro_RO ru_RU si_LK sk_SK sl_SI sr_RS sv_SE sw_TZ ta_IN te_IN th_TH tl_PH tr_TR uk_UA vi_VN zh_CN zh_HK zh_TW zu_ZA en_XA ar_XB

# Disable Prime Shader Cache in SurfaceFlinger to make it available faster
PRODUCT_PROPERTY_OVERRIDES += \
    service.sf.prime_shader_cache=0

# should add to BOOT_JARS only once
ifeq (,$(INCLUDED_ANDROID_CAR_TO_PRODUCT_BOOT_JARS))
PRODUCT_BOOT_JARS += \
    android.car

PRODUCT_HIDDENAPI_STUBS := \
    android.car-stubs-dex

PRODUCT_HIDDENAPI_STUBS_SYSTEM := \
    android.car-system-stubs-dex

PRODUCT_HIDDENAPI_STUBS_TEST := \
    android.car-test-stubs-dex

$(call inherit-product-if-exists, vendor/app-prebuilt/renesas_app.mk)

INCLUDED_ANDROID_CAR_TO_PRODUCT_BOOT_JARS := yes
endif

$(call inherit-product-if-exists, vendor/app-prebuilt/renesas_app.mk)

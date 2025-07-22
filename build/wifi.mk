## build packages
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    wlutil \
    wificond \
    wifilogd \
    wpa_supplicant \
    wpa_supplicant_xenvm.conf

PRODUCT_PACKAGES += \
    libwpa_client \
    libwifilogd \
    libcld80211

PRODUCT_PACKAGES += xenvm_overlay_connectivity

## service init.rc scripts
PRODUCT_COPY_FILES += device/xen/xenvm/wifi/init.xenvm.wifi.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/wifi.rc

# Hardware permissions
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml
# Permission for Wi-Fi passpoint support
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml

# mt7610u firmware
PRODUCT_COPY_FILES += device/xen/xenvm/wifi/firmware/mediatek/mt7610u.bin:vendor/firmware/mediatek/mt7610u.bin

## feature wifi properties
PRODUCT_PROPERTY_OVERRIDES += wifi.interface=wlan0

WIFI_HAL_INTERFACE_COMBINATIONS := {{{STA}, 1}, {{AP}, 1}, {{P2P}, 1}}

BOARD_WLAN_DEVICE := qcwcn
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := 
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := 


#!/system/bin/sh

# Find Tp-Link UB500 Realtek 8761B Bluetooth device
VENDOR_ID="2357"
PRODUCT_ID="0604"

# Search for the device path
DEVICE_PATH=""
for dev in /sys/bus/usb/devices/*; do
    if [ -f "$dev/idVendor" ] && [ -f "$dev/idProduct" ]; then
        if grep -q "$VENDOR_ID" "$dev/idVendor" && grep -q "$PRODUCT_ID" "$dev/idProduct"; then
            DEVICE_PATH="$dev"
            break
        fi
    fi
done

if [ -n "$DEVICE_PATH" ]; then
    # Extract the bus and device numbers
    # Get busnum and devnum from sysfs
    BUS_NUM=$(cat "$DEVICE_PATH/busnum")
    DEV_NUM=$(cat "$DEVICE_PATH/devnum")

    # Format as 3-digit numbers (as in /dev/bus/usb/XXX/YYY)
    BUS_NUM=$(printf "%03d" "$BUS_NUM")
    DEV_NUM=$(printf "%03d" "$DEV_NUM")

    DEVICE_NODE="/dev/bus/usb/$BUS_NUM/$DEV_NUM"
    log -t usb_bt_init "Device node is $DEVICE_NODE"

    # Create the symlink
    ln -sf $DEVICE_NODE /dev/usb-bluetooth

    # Set permissions and ownership
    chmod 0660 /dev/usb-bluetooth
    chown bluetooth:bluetooth /dev/usb-bluetooth

    # Log the event
    log -t usb_bt_init "USB Bluetooth device symlink created"
else
    # Log the error
    log -t usb_bt_init "USB Bluetooth device not found"
fi

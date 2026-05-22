#!/bin/bash

THEME_NAME="lapulapu-grub-theme"
THEME_DIR="/boot/grub/themes/$THEME_NAME"
GRUB_CONFIG="/etc/default/grub"

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo ./uninstall.sh"
    exit 1
fi

sed -i '/^GRUB_THEME=/d' "$GRUB_CONFIG"
sed -i '/^GRUB_GFXPAYLOAD_LINUX=keep/d' "$GRUB_CONFIG"

rm -rf "$THEME_DIR"

update-grub

echo "Uninstalled successfully."

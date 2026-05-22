#!/bin/bash

THEME_NAME="lapulapu-grub-theme"
THEME_DIR="/boot/grub/themes/$THEME_NAME"
GRUB_CONFIG="/etc/default/grub"

GREEN="\033[0;32m"
RED="\033[0;31m"
CYAN="\033[0;36m"
BOLD="\033[1;37m"
RESET="\033[0m"

echo -e "${BOLD}\n\t================================"
echo -e "\t  Lapu-Lapu GRUB Theme"
echo -e "\t================================${RESET}\n"

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root: sudo ./install.sh${RESET}"
    exit 1
fi

echo -e "${CYAN}[1/4] Copying theme files...${RESET}"
mkdir -p "$THEME_DIR"
cp -r ./* "$THEME_DIR/"
echo -e "${GREEN}      Done${RESET}"

echo -e "${CYAN}[2/4] Generating fonts...${RESET}"
if command -v grub-mkfont &> /dev/null; then
    cd "$THEME_DIR"
    if [ -f "fonts/PermanentMarker-Regular.ttf" ]; then
        grub-mkfont -s 52 -o menu_font.pf2 fonts/PermanentMarker-Regular.ttf 2>/dev/null
        grub-mkfont -s 18 -o timer_font.pf2 fonts/PermanentMarker-Regular.ttf 2>/dev/null
    fi
    cd - > /dev/null
fi
echo -e "${GREEN}      Done${RESET}"

echo -e "${CYAN}[3/4] Updating GRUB config...${RESET}"
cp "$GRUB_CONFIG" "$GRUB_CONFIG.bak"

sed -i '/^GRUB_THEME=/d' "$GRUB_CONFIG"
sed -i '/^GRUB_BACKGROUND=/d' "$GRUB_CONFIG"
sed -i '/^GRUB_GFXPAYLOAD_LINUX=/d' "$GRUB_CONFIG"

echo 'GRUB_GFXPAYLOAD_LINUX=keep' >> "$GRUB_CONFIG"

if grep -q "^GRUB_GFXMODE" "$GRUB_CONFIG"; then
    sed -i 's/^GRUB_GFXMODE=.*/GRUB_GFXMODE="1280x720"/' "$GRUB_CONFIG"
elif grep -q "^#GRUB_GFXMODE" "$GRUB_CONFIG"; then
    sed -i 's/^#GRUB_GFXMODE=.*/GRUB_GFXMODE="1280x720"/' "$GRUB_CONFIG"
else
    echo 'GRUB_GFXMODE="1280x720"' >> "$GRUB_CONFIG"
fi

echo "GRUB_THEME=\"$THEME_DIR/theme.txt\"" >> "$GRUB_CONFIG"
echo -e "${GREEN}      Done${RESET}"

echo -e "${CYAN}[4/4] Running update-grub...${RESET}"
update-grub

echo -e "${GREEN}${BOLD}\n\t================================"
echo -e "\t  Successfully installed!"
echo -e "\t  Reboot to see the theme"
echo -e "\t================================${RESET}\n"

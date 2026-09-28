#!/bin/bash

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "[-] Please run this script with sudo: sudo bash ~/switch-display.sh"
  exit 1
fi

# Locate the correct config and cmdline file paths (handling newer and older OS structures)
CONFIG_FILE="/boot/firmware/config.txt"
if [ ! -f "$CONFIG_FILE" ]; then
    CONFIG_FILE="/boot/config.txt"
fi

CMDLINE_FILE="/boot/firmware/cmdline.txt"
if [ ! -f "$CMDLINE_FILE" ]; then
    CMDLINE_FILE="/boot/cmdline.txt"
fi

echo "==========================================="
echo "   Raspberry Pi Display Switching Tool"
echo "==========================================="
echo "Which display do you want to use?"
echo "  1) HDMI"
echo "  2) GPIO Screen"
read -p "Enter choice [1 or 2]: " choice

case $choice in
    1)
        echo "[*] Configuring system for HDMI..."
        # Re-enable standard KMS graphics driver
        sed -i 's/^#dtoverlay=vc4-kms-v3d/dtoverlay=vc4-kms-v3d/' "$CONFIG_FILE"
        # Disable piscreen overlay
        sed -i 's/^dtoverlay=piscreen/#dtoverlay=piscreen/' "$CONFIG_FILE"
        
        # Remove GPIO framebuffer mapping from cmdline if present
        if [ -f "$CMDLINE_FILE" ]; then
            sudo sed -i 's/ fbcon=map:10//g' "$CMDLINE_FILE"
        fi
        ;;
    2)
        echo "[*] Configuring system for GPIO Screen..."
        # Ensure SPI hardware is enabled
        if ! grep -q "^dtparam=spi=on" "$CONFIG_FILE"; then
            echo "dtparam=spi=on" >> "$CONFIG_FILE"
        fi
        
        # Disable standard KMS driver to avoid conflicts
        sed -i 's/^dtoverlay=vc4-kms-v3d/#dtoverlay=vc4-kms-v3d/' "$CONFIG_FILE"
        
        # Add or uncomment piscreen overlay
        if ! grep -q "dtoverlay=piscreen" "$CONFIG_FILE"; then
            echo "dtoverlay=piscreen,speed=16000000,rotate=90" >> "$CONFIG_FILE"
        else
            sed -i 's/^#dtoverlay=piscreen/dtoverlay=piscreen/' "$CONFIG_FILE"
        fi
        
        # Add framebuffer console mapping to cmdline if not already present
        if [ -f "$CMDLINE_FILE" ]; then
            if ! grep -q "fbcon=map:10" "$CMDLINE_FILE"; then
                sudo sed -i 's/$/ fbcon=map:10/' "$CMDLINE_FILE"
            fi
        fi
        ;;
    *)
        echo "[-] Invalid selection. Exiting without changes."
        exit 1
        ;;
esac

echo ""
echo "[+] Configuration updated successfully!"
echo "[+] Rebooting Raspberry Pi in 3 seconds..."
sleep 3
reboot
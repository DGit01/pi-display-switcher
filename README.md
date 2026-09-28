# pi-display-switcher
A Bash script to dynamically switch a Raspberry Pi between standard HDMI output and a GPIO/SPI TFT display (with automatic framebuffer remapping)


# Raspberry Pi Display Switcher 🖥️⚡

A lightweight, portable Bash script designed to instantly toggle your Raspberry Pi between **HDMI** and a **GPIO/SPI TFT Display** (such as a 3.5" PiScreen) without manual configuration headaches. 

It automatically handles device-tree overlays (`config.txt`), graphic driver conflicts (`vc4-kms-v3d`), and console framebuffer remapping (`cmdline.txt`) in one seamless step.

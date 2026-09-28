```markdown
# Pi Display Switcher

A simple tool to switch your Raspberry Pi's display between a standard **HDMI monitor** and a **GPIO/SPI small screen** (like a 3.5" touchscreen) with a single command.

---

## The Problem It Solves
If you've ever tried using a cheap GPIO screen on a Raspberry Pi, you know it requires editing system files (`config.txt` and `cmdline.txt`) and disabling standard graphics drivers. If you want to switch back to HDMI later, you have to undo it all manually. 

This script automates the entire headache into an interactive menu.

---

## Quick Start (For Beginners & Pros)

Log into your Raspberry Pi via SSH and run this single command to download and run the script instantly:

```bash
curl -sO [https://raw.githubusercontent.com/DGit01/pi-display-switcher/main/switch-display.sh](https://raw.githubusercontent.com/DGit01/pi-display-switcher/main/switch-display.sh) && chmod +x switch-display.sh && sudo bash switch-display.sh

```

The script will ask you:

```text
Which display do you want to use?
  1) HDMI
  2) GPIO Screen

```

Pick your choice, and the Pi will automatically apply the configuration changes and reboot!

---

## How It Works (For Techies)

Under the hood, the script handles the configuration adjustments needed for modern Raspberry Pi OS:

1. **HDMI Mode:**
* Re-enables the standard KMS driver (`dtoverlay=vc4-kms-v3d`).
* Disables the SPI display overlay (`piscreen`).
* Removes console framebuffer mapping (`fbcon=map:10`) from `cmdline.txt` so normal video output returns to HDMI.


2. **GPIO Screen Mode:**
* Ensures SPI hardware is turned on (`dtparam=spi=on`).
* Disables the conflicting `vc4-kms-v3d` graphics driver.
* Injects the SPI display overlay (default: `dtoverlay=piscreen,speed=16000000,rotate=90`).
* Appends `fbcon=map:10` to `cmdline.txt` to route text console output straight to the SPI framebuffer.



---

## Compatibility

* **Tested On:** Raspberry Pi Model 3B (Headless Raspberry Pi OS) and compatible 3.5" SPI TFT displays.
* **OS Path Support:** Automatically detects whether your system uses `/boot/firmware/config.txt` or the legacy `/boot/config.txt` structure.

```

```

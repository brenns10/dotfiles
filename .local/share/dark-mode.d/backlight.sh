#!/bin/bash
DEV="tpacpi::kbd_backlight"
if hash brightnessctl && [ -f "/sys/class/leds/$DEV/brightness" ]; then
    brightnessctl --device="$DEV" set 2
else
    echo "Backlight not found"
fi

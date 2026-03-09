#!/bin/bash

WALLPAPER_ID=${1:-"3660522497"}

linux-wallpaperengine --slient --screen-root HDMI-A-1 --bg ${WALLPAPER_ID} --scaling fill \
  --screen-root DVI-I-1 --bg ${WALLPAPER_ID} --screenshot ~/.cache/wallpaper-engine/output.png \
  --screen-root DP-1 --bg ${WALLPAPER_ID}

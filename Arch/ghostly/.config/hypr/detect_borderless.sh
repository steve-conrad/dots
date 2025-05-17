#!/bin/bash

# Get active monitor resolution
SCREEN_WIDTH=$(hyprctl monitors -j | jq -r '.[0].width')
SCREEN_HEIGHT=$(hyprctl monitors -j | jq -r '.[0].height')

# Check if any window matches screen size
if hyprctl clients -j | jq -e --argjson w "$SCREEN_WIDTH" --argjson h "$SCREEN_HEIGHT" '
    .[] | select(.at[0] == 0 and .at[1] == 0 and .size[0] == $w and .size[1] == $h)
' > /dev/null; then
    echo "Borderless fullscreen detected"
    exit 0
else
    echo "No borderless fullscreen app"
    exit 1
fi

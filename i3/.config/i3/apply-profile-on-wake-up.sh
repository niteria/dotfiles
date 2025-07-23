#!/usr/bin/env nix-shell
#!nix-shell -i bash -p xdotool

# Move mouse to "Apply Profile" (x: 2350, y: 1080) and click
xdotool mousemove 2350 1080 click 1

# Wait for UI to update
sleep 4

# # Move mouse to "Close" (x: 2380, y: 1155) and click
# xdotool mousemove 2380 1155 click 1

# it has a different position after the profile is applied
# TODO: maybe I can just close the window by name
#xdotool mousemove 5040 970 click 1

# close by name
xdotool search --name "^Displays$" windowclose %@

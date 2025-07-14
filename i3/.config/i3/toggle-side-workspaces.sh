#!/usr/bin/env bash

# Define your workspace names for the two sets
set1_ws=("4" "5")
set2_ws=("1: left" "3: right")

# Get all visible workspaces
visible_ws=$(i3-msg -t get_workspaces | jq -r '.[] | select(.visible==true) | .name')

# Check if any workspace from set1 is visible on any monitor
if echo "$visible_ws" | grep -qE "^(${set1_ws[0]}|${set1_ws[1]})$"; then
  # If yes, switch to set2 workspaces on the corresponding outputs
  i3-msg "focus output DP-2; workspace ${set2_ws[0]}; focus output HDMI-1; workspace ${set2_ws[1]}; focus output DP-0"
else
  # Otherwise, switch to set1 workspaces
  i3-msg "focus output DP-2; workspace ${set1_ws[0]}; focus output HDMI-1; workspace ${set1_ws[1]}; focus output DP-0"
fi

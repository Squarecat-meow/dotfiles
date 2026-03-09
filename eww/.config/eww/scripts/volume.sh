#!/bin/bash
get_vol() {
  vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
  pct=$(echo "$vol" | awk '{printf "%d", $2 * 100}')
  muted=$(echo "$vol" | grep -q MUTED && echo "true" || echo "false")
  echo "{\"pct\":$pct,\"muted\":$muted}"
}

get_vol
pactl subscribe | while read -r line; do
  if [[ "$line" == *"sink"* ]]; then
    get_vol
  fi
done

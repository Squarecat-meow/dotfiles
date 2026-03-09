#!/bin/bash
# System info: Ethernet status + Bluetooth status
# Output: {"eth_iface": "enp42s0", "eth_up": true, "bt_name": "...", "bt_connected": true}

# 유선 인터페이스 탐색
eth_iface=""
for iface in /sys/class/net/*/operstate; do
  dir=$(dirname "$iface")
  name=$(basename "$dir")
  [[ "$name" == lo || "$name" == docker* || "$name" == br-* || "$name" == tailscale* || "$name" == veth* ]] && continue
  if [[ "$(cat "$iface" 2>/dev/null)" == "up" ]]; then
    eth_iface="$name"
    break
  fi
done

eth_up=false
[[ -n "$eth_iface" ]] && eth_up=true

bt_info=$(bluetoothctl devices Connected 2>/dev/null | head -1)
if [[ -n "$bt_info" ]]; then
  bt_name=$(echo "$bt_info" | sed 's/Device [^ ]* //')
  bt_connected=true
else
  bt_name=""
  bt_connected=false
fi

jq -cn --arg ei "$eth_iface" --argjson eu "$eth_up" \
       --arg bn "$bt_name" --argjson bc "$bt_connected" \
  '{eth_iface: $ei, eth_up: $eu, bt_name: $bn, bt_connected: $bc}'

#!/bin/bash
# Network speed monitor for eww deflisten
# Outputs JSON: {"rx": "1.2 MB/s", "tx": "340 KB/s", "rx_pct": 12, "tx_pct": 3}
# rx_pct/tx_pct: percentage of 100Mbps (12.5 MB/s)

IFACE=""
for iface in /sys/class/net/*/operstate; do
  dir=$(dirname "$iface")
  name=$(basename "$dir")
  [[ "$name" == "lo" || "$name" == docker* || "$name" == br-* || "$name" == tailscale* || "$name" == veth* ]] && continue
  if [[ "$(cat "$iface" 2>/dev/null)" == "up" ]]; then
    IFACE="$name"
    break
  fi
done

[[ -z "$IFACE" ]] && IFACE="enp42s0"

MAX_BYTES=$((100 * 1000000 / 8))  # 100Mbps in bytes/s

format_speed() {
  local bytes=$1
  if (( bytes >= 1048576 )); then
    awk "BEGIN {printf \"%.1f MB/s\", $bytes/1048576}"
  elif (( bytes >= 1024 )); then
    awk "BEGIN {printf \"%.0f KB/s\", $bytes/1024}"
  else
    echo "${bytes} B/s"
  fi
}

prev_rx=$(cat /sys/class/net/"$IFACE"/statistics/rx_bytes 2>/dev/null || echo 0)
prev_tx=$(cat /sys/class/net/"$IFACE"/statistics/tx_bytes 2>/dev/null || echo 0)

while true; do
  sleep 1
  curr_rx=$(cat /sys/class/net/"$IFACE"/statistics/rx_bytes 2>/dev/null || echo 0)
  curr_tx=$(cat /sys/class/net/"$IFACE"/statistics/tx_bytes 2>/dev/null || echo 0)

  rx_diff=$((curr_rx - prev_rx))
  tx_diff=$((curr_tx - prev_tx))
  (( rx_diff < 0 )) && rx_diff=0
  (( tx_diff < 0 )) && tx_diff=0

  rx_str=$(format_speed $rx_diff)
  tx_str=$(format_speed $tx_diff)
  rx_pct=$((rx_diff * 100 / MAX_BYTES))
  tx_pct=$((tx_diff * 100 / MAX_BYTES))
  (( rx_pct > 100 )) && rx_pct=100
  (( tx_pct > 100 )) && tx_pct=100

  jq -cn --arg rx "$rx_str" --arg tx "$tx_str" --argjson rp "$rx_pct" --argjson tp "$tx_pct" \
    '{rx: $rx, tx: $tx, rx_pct: $rp, tx_pct: $tp}'

  prev_rx=$curr_rx
  prev_tx=$curr_tx
done

#!/bin/bash
# 개별 알림 닫기

NOTIF_FILE="/tmp/eww_notifications.json"
LOCK_FILE="/tmp/eww_notifications.lock"

dismiss_id="$1"
[ -z "$dismiss_id" ] && exit 1

(
  flock -w 2 200 || exit 1

  current=$(cat "$NOTIF_FILE" 2>/dev/null || echo '[]')
  updated=$(echo "$current" | jq --arg id "$dismiss_id" 'map(select(.id != $id))')

  echo "$updated" > "$NOTIF_FILE"
  /home/yozumina/git/eww/target/release/eww update notifications="$updated"

) 200>"$LOCK_FILE"

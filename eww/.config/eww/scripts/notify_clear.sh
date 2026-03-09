#!/bin/bash
# 전체 알림 클리어

NOTIF_FILE="/tmp/eww_notifications.json"
LOCK_FILE="/tmp/eww_notifications.lock"

(
  flock -w 2 200 || exit 1

  echo '[]' > "$NOTIF_FILE"
  /home/yozumina/git/eww/target/release/eww update notifications='[]'

) 200>"$LOCK_FILE"

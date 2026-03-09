#!/bin/bash
# dunst script hook -> eww 알림 브릿지
# dunst script args: appname summary body icon urgency

NOTIF_FILE="/tmp/eww_notifications.json"
LOCK_FILE="/tmp/eww_notifications.lock"
MAX_NOTIFS=5

appname="${1:-}"
summary="${2:-}"
body="${3:-}"
icon_raw="${4:-}"
urgency="${5:-NORMAL}"

# 아이콘 경로 확인: 파일 경로면 그대로, 아이콘 이름이면 찾기
icon=""
if [ -n "$icon_raw" ]; then
  if [ -f "$icon_raw" ]; then
    icon="$icon_raw"
  else
    # 아이콘 이름으로 파일 경로 검색
    found=$(find /usr/share/icons/Papirus/48x48 /usr/share/icons/hicolor/48x48 /usr/share/pixmaps \
      -name "${icon_raw}.*" -o -name "${icon_raw}" 2>/dev/null | head -1)
    [ -n "$found" ] && icon="$found"
  fi
fi

case "$urgency" in
  LOW)      timeout=5 ;;
  CRITICAL) timeout=0 ;;
  *)        timeout=8 ;;
esac

id="$(date +%s%N)"

[ -f "$NOTIF_FILE" ] || echo '[]' > "$NOTIF_FILE"

(
  flock -w 2 200 || exit 1

  current=$(cat "$NOTIF_FILE" 2>/dev/null || echo '[]')

  new_notif=$(jq -cn \
    --arg id "$id" \
    --arg app "$appname" \
    --arg sum "$summary" \
    --arg body "$body" \
    --arg icon "$icon" \
    --arg urg "$urgency" \
    --argjson timeout "$timeout" \
    '{id: $id, app: $app, summary: $sum, body: $body, icon: $icon, urgency: $urg, timeout: $timeout}')

  updated=$(echo "$current" | jq --argjson n "$new_notif" --argjson max "$MAX_NOTIFS" \
    '. + [$n] | .[-$max:]')

  echo "$updated" > "$NOTIF_FILE"
  /home/yozumina/git/eww/target/release/eww update notifications="$updated"

) 200>"$LOCK_FILE"

if [ "$timeout" -gt 0 ]; then
  (
    sleep "$timeout"
    /home/yozumina/.config/eww/scripts/notify_dismiss.sh "$id"
  ) &
  disown
fi

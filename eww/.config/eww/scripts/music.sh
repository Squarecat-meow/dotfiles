#!/bin/bash
# playerctl metadata를 JSON으로 스트림
# 출력: {"artist": "...", "title": "...", "status": "Playing|Paused|Stopped", "art": "/tmp/eww_album_art.jpg"}

emit() {
  artist=$(playerctl metadata artist 2>/dev/null || echo "")
  title=$(playerctl metadata title 2>/dev/null || echo "")
  status=$(playerctl status 2>/dev/null || echo "Stopped")

  art_url=$(playerctl metadata mpris:artUrl 2>/dev/null || echo "")
  art=""
  if [[ -n "$art_url" ]]; then
    if [[ "$art_url" == file://* ]]; then
      art="${art_url#file://}"
    else
      curl -sL "$art_url" -o /tmp/eww_album_art.jpg 2>/dev/null && art="/tmp/eww_album_art.jpg"
    fi
  fi

  jq -cn --arg a "$artist" --arg t "$title" --arg s "$status" --arg art "$art" \
    '{artist: $a, title: $t, status: $s, art: $art}'
}

# 초기 출력
emit

# --follow의 출력을 트리거로만 사용, 변경 시마다 개별 조회
playerctl metadata --follow 2>/dev/null | while read -r _; do
  emit
done

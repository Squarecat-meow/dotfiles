#!/bin/bash
# 특정 모니터의 워크스페이스 목록을 JSON 배열로 실시간 스트리밍
# 사용법: workspaces.sh <monitor_name>
# 예: workspaces.sh DP-1

MONITOR="${1:?Usage: workspaces.sh <monitor_name>}"

query() {
  niri msg -j workspaces | jq -c --arg mon "$MONITOR" \
    '[.[] | select(.output == $mon) | {id: .id, idx: .idx, name: (.name // .idx | tostring), is_active: .is_active, is_focused: .is_focused}] | sort_by(.idx)'
}

# 초기 출력
query

# 워크스페이스 변경 또는 활성화 이벤트 시 재조회
niri msg -j event-stream | jq -c --unbuffered 'if .WorkspacesChanged or .WorkspaceActivated then "update" else empty end' | while read -r _; do
  query
done

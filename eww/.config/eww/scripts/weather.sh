#!/bin/bash
# wttr.in JSON → 현재 날씨 + 3일 예보
# defpoll용 (단일 JSON 출력)
# 30분 파일 캐시 (/tmp/eww_weather_cache.json)

CACHE="/tmp/eww_weather_cache.json"
MAX_AGE=1800 # 30분

if [[ -f "$CACHE" ]]; then
  age=$(($(date +%s) - $(stat -c %Y "$CACHE")))
  if ((age < MAX_AGE)); then
    cat "$CACHE"
    exit 0
  fi
fi

weather_icon() {
  case "$1" in
  113) printf '☀\uFE0F' ;;
  116) printf '⛅\uFE0F' ;;
  119 | 122) printf '☁\uFE0F' ;;
  143 | 248 | 260) printf '🌫\uFE0F' ;;
  176 | 263 | 266 | 293 | 296) printf '🌦\uFE0F' ;;
  179 | 182 | 185 | 281 | 284 | 311 | 314 | 317) printf '🌨\uFE0F' ;;
  200 | 386 | 389 | 392 | 395) printf '⛈\uFE0F' ;;
  227 | 230 | 320 | 323 | 326 | 329 | 332 | 335 | 338 | 350 | 368 | 371 | 374 | 377) printf '❄\uFE0F' ;;
  299 | 302 | 305 | 308 | 356 | 359) printf '🌧\uFE0F' ;;
  *) printf '🌡\uFE0F' ;;
  esac
}

day_label() {
  local idx=$1
  case "$idx" in
  0) echo "오늘" ;;
  1) echo "내일" ;;
  2) echo "모레" ;;
  esac
}

data=$(curl -s --max-time 10 'wttr.in/Yongin?format=j1' 2>/dev/null)
if [[ -z "$data" ]]; then
  # fetch 실패 시 만료된 캐시라도 반환
  [[ -f "$CACHE" ]] && cat "$CACHE" && exit 0
  echo '{"ok":false}' && exit 0
fi

cur_temp=$(echo "$data" | jq -r '.current_condition[0].temp_C')
cur_code=$(echo "$data" | jq -r '.current_condition[0].weatherCode')
cur_desc=$(echo "$data" | jq -r '.current_condition[0].weatherDesc[0].value' | xargs)
cur_humid=$(echo "$data" | jq -r '.current_condition[0].humidity')
cur_wind=$(echo "$data" | jq -r '.current_condition[0].windspeedKmph')
cur_icon=$(weather_icon "$cur_code")

forecast="["
for i in 0 1 2; do
  maxtemp=$(echo "$data" | jq -r ".weather[$i].maxtempC")
  mintemp=$(echo "$data" | jq -r ".weather[$i].mintempC")
  code=$(echo "$data" | jq -r ".weather[$i].hourly[4].weatherCode")
  icon=$(weather_icon "$code")
  label=$(day_label "$i")
  [[ $i -gt 0 ]] && forecast+=","
  forecast+="{\"label\":\"$label\",\"icon\":\"$icon\",\"min\":\"$mintemp\",\"max\":\"$maxtemp\"}"
done
forecast+="]"

result=$(jq -cn --arg temp "$cur_temp" --arg icon "$cur_icon" --arg desc "$cur_desc" \
  --arg humid "$cur_humid" --arg wind "$cur_wind" \
  --argjson forecast "$forecast" \
  '{ok: true, temp: $temp, icon: $icon, desc: $desc, humid: $humid, wind: $wind, forecast: $forecast}')

echo "$result" | tee "$CACHE"

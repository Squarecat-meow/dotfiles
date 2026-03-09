#!/bin/bash
# cava raw ASCII output → JSON array for eww deflisten
# Each frame: semicolon-separated values → JSON array

cava -p ~/.config/cava/config | while IFS=';' read -ra bars; do
  json="["
  first=true
  for b in "${bars[@]}"; do
    b="${b%%[[:space:]]}"
    b="${b##[[:space:]]}"
    [[ -z "$b" ]] && continue
    $first || json+=","
    json+="$b"
    first=false
  done
  json+="]"
  echo "$json"
done

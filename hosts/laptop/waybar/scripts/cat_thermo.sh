
json_response=$(curl -sf "http://192.168.0.230:9090/")

current_temp=$(echo "$json_response" | jq -r '.temperature_fahrenheit')

jq -nc --arg text "🐱 $current_temp°" '{"text": $text}'

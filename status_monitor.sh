#!/bin/bash

# colors
green='\033[0;32m'
red='\033[0;31m'
no_color='\033[0m'
#symbols
HARD_DRIVE='💽'
CALENDAR='📆'
CLOCK='🕓'
WHALE='🐳'
HEART_FULL=♥
HEART_EMPTY=♡
CAT_PAWS='🐾'
HEARTS=5
# variables
AVAILABLE_SPACE=$(df -h | grep fedora-root | grep -oP '[0-9].%')
BATERY_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
TIME=$(date +"%H:%M")
DATE=$(date +"%d-%m-%y")
# docker container count
if docker ps > /dev/null 2>&1; then
  CONTAINER_COUNT=`expr $(docker ps | wc -l) - 1`
  DOCKER="$WHALE $CONTAINER_COUNT"
fi
# battery level
battery_level()
{
  current=$1
  inc=$(( 100 / $HEARTS))
  min=11
  heart_level=''
  for i in `seq $HEARTS`; do
    if [ $current -gt $min ]; then
      heart_level="$heart_level $HEART_FULL"
    else
      heart_level="$heart_level $HEART_EMPTY"
    fi
    min=$(( $min + $inc ))
  done
  echo $heart_level
}

# charger status
charger_status()
{
  status=$(cat /sys/class/power_supply/BAT0/status)
  if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
    echo '🔌'
  else
    echo '🔋'
  fi
}

CUTE_BATTERY="$(charger_status) $(battery_level $BATERY_LEVEL)"

echo -e "$DOCKER | $CUTE_BATTERY | $HARD_DRIVE $AVAILABLE_SPACE | $CLOCK $TIME | $CALENDAR $DATE "
# echo -e "${green}$AVAILABLE_SPACE${no_color}"


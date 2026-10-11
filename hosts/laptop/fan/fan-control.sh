#!/bin/bash
# Hysteresis fan control for the X1 Carbon 4th gen (20FR). The EC's
# own curve hunts between two speeds every ~5s under sustained load;
# this steps up as soon as the smoothed temp crosses a threshold, but
# only steps down once it has stayed below the lower threshold for
# HOLD seconds.
#
# Needs "options thinkpad_acpi fan_control=1" in /etc/modprobe.d/.
# The EC watchdog hands control back to auto if this script dies.
#
# Install (as root):
#   install -m 755 fan-control.sh /usr/local/sbin/fan-control
#   install -m 644 fan-control.service /etc/systemd/system/
#   systemctl daemon-reload && systemctl enable --now fan-control

FAN=/proc/acpi/ibm/fan
INTERVAL=2      # seconds between reads
HOLD=30         # seconds below DOWN before stepping down a level
WATCHDOG=30     # EC reverts to auto if not written to for this long

# Per step: EC level, temp (C) to step up into it, temp to step down out of it.
# Measured rpm: 1=3200 2=4200 3=5200 4=5500 5=6300 6=7=6900, so 4 and 6
# are skipped.
LEVEL=(0          1  2  3  5  7  full-speed)
UP=(   0         50 58 65 72 78  90)
DOWN=( 0         45 53 60 67 73  84)

for d in /sys/class/hwmon/hwmon*; do
    [ "$(cat "$d/name")" = coretemp ] && TEMP="$d/temp1_input"
done
[ -n "$TEMP" ] || { echo "coretemp not found" >&2; exit 1; }

trap 'echo "level auto" > $FAN; exit' INT TERM EXIT
echo "watchdog $WATCHDOG" > $FAN

cur=$(( ${#LEVEL[@]} - 1 ))   # start high, settle down
below=0
avg=$(( $(cat "$TEMP") / 1000 ))
while :; do
    # Package temp jumps 10C for a single sample under bursty load;
    # an EMA (~8s time constant) keeps those from moving the fan.
    avg=$(( (avg * 3 + $(cat "$TEMP") / 1000 + 2) / 4 ))
    t=$avg

    target=0
    for i in "${!UP[@]}"; do
        (( t >= UP[i] )) && target=$i
    done

    if (( target > cur )); then
        cur=$target
        below=0
    elif (( cur > 0 && t < DOWN[cur] )); then
        below=$(( below + INTERVAL ))
        if (( below >= HOLD )); then
            cur=$(( cur - 1 ))
            below=0
        fi
    else
        below=0
    fi

    # Rewritten every pass to keep the EC watchdog fed.
    echo "level ${LEVEL[cur]}" > $FAN
    sleep $INTERVAL
done

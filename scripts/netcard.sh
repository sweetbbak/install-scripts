#!/usr/bin/env bash

shopt -s nullglob
# paths=(/sys/class/net/[ew]*/statistics/rx_bytes)
paths=(/sys/class/net/wlan0/statistics/rx_bytes)

# No network card?
(( ! ${#paths[@]} )) &&
	exit 1

bytes1=0
bytes2=0

for path in "${paths[@]}"; do
	read -r rx_bytes <"$path"
	(( bytes1+=rx_bytes ))
done

sleep 1

for path in "${paths[@]}"; do
	read -r rx_bytes <"$path"
	(( bytes2+=rx_bytes ))
done

bps=$((bytes2 - bytes1))

precision=1

if (( bps >= 10**12 )); then   # Terra
	whole=${bps%????????????}
	unit=T
elif (( bps >= 10**9 )); then  # Giga
	whole=${bps%?????????}
	unit=G
elif (( bps >= 10**6 )); then  # Mega
	whole=${bps%??????}
	unit=M
elif (( bps >= 10**3 )); then  # Kilo
	whole=${bps%???}
	unit=k
else
	whole=$bps
	unit=
	precision=0
fi

fraction=${bps#"$whole"}
printf -v net_speed "   %.*f %sB/s \n" "$precision" "$whole.$fraction" "$unit"

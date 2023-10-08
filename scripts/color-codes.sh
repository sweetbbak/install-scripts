#!/bin/bash

echo "PALETTE OF 8 COLORS (bold, high intensity, normal, faint)"
for i in {30..37}; do printf "\e[1;${i}m1;%-2s      \e[m" "$i"; done; echo
for i in {90..97}; do printf "\e[${i}m%+4s      \e[m" "$i"; done; echo
for i in {30..37}; do printf "\e[${i}m%+4s      \e[m" "$i"; done; echo
for i in {30..37}; do printf "\e[2;${i}m2;%-2s      \e[m" "$i"; done;

echo -e "\n\n\nPALETTE OF 256 COLORS (only normal)"
j=8
for i in {0..255}; do
    [[ $i = 16 ]] && j=6
    [[ $i = 232 ]] && j=8
    printf "\e[38;5;${i}m38;5;%-4s\e[m" "${i}"
    (( i>15 && i<232 )) && printf "\e[52C\e[1;38;5;${i}m1;38;5;%-4s\e[52C\e[m\e[2;38;5;${i}m2;38;5;%-4s\e[m\e[126D" "${i}" "${i}"
    [[ $(( $(( $i - 15 )) % $j )) = 0 ]] && echo
    [[ $(( $(( $i - 15 )) % $(( $j * 6 )) )) = 0 ]] && echo
done
exit 0

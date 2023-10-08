#!/bin/bash
set -x
# readarray -d '' array < <(fd . ~/Pictures ~/ssd/gallery-dl -0 -e png -e jpg -e webp -e gif -e jpeg)
readarray -d '' array < <(fd . ~/Pictures/backgrounds -0 -e png -e jpg -e webp -e gif -e jpeg)

aspect() {
    a="$1" ; b="$2"
    if [[ a -le b ]]; then
        echo "$x is a vertical image"
    fi
    if [[ "$b" == 0 ]]; then 
        printf "greatest common denominator\e[31m%s\e[0m\n" "$a"
        gcd="$a"

    else
        mod=$(( a % b ))
        printf "\e[31m%s %s\e[0m\n" "$a" "$b"
        aspect "$b" "$mod"
    fi
}

# x="${array[9]}"
x="$(printf "%s\n" "${array[@]}"|shuf -n1)"
# # width
W=$(identify "$x" | cut -f 3 -d " " | sed s/x.*//) 
# # height
H=$(identify "$x" | cut -f 3 -d " " | sed s/.*x//)

printf "image: \e[31m%s\e[0m\n" "$x"
printf "width: \e[31m%s\e[0m \nheight: \e[31m%s\e[0m\n" "$W" "$H"
printf "\e[33m%s\e[0m\n" "--------------------"
# W=1920 ; H=1080
aspect "$W" "$H"
W="$((W / gcd))"
H="$((H / gcd))"
printf "\e[33mRATIO %s:%s\e[0m\n" "$W" "$H"

# for x in "${array[@]}"; do
#     # width
#     W=$(identify "$x" | cut -f 3 -d " " | sed s/x.*//) 
#     # height
#     H=$(identify "$x" | cut -f 3 -d " " | sed s/.*x//)
# done

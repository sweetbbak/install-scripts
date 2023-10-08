#!/bin/bash

stty -echo

trap 'end 130' EXIT INT
trap init_term WINCH

init_term(){
  IFS='[;' read -sp $'\e[999;999H\e[6n' -d R -rs _ LINES COLUMNS
  ((ROWS=LINES-1))
  ((snakeX=COLUMNS/2)); ((snakeY=ROWS/2))
  CENTER="$snakeY;$snakeX"
  
  printf '\e[?1049h\e[2J\e[?25l'
  rand_block
}

read_keys() {
  case $1 in
    20) n=.7;; 19) n=.6;; 18) n=.5;; 17) n=.4;; 16) n=.3;; 15) n=.2;; 14)n=.1;;
    13) n=.09;; 12) n=.08;; 11) n=.075;; 10) n=.07;; 9) n=.065;; 8) n=.06;; 7) n=.055;;
    6) n=.05;; 5) n=.045;; 4) n=.04;; 3) n=.035;; 2) n=.03;; 1) n=.025;;
  esac

  while read -rsn1 -t "$n"; do
    [[ $REPLY == $'\e' ]]&& read -rsn2 -t "$n"
    KEY="${REPLY^^}"
  done
}

rand_block(){
  ((blockX=SRANDOM%COLUMNS+1)); ((blockY=SRANDOM%ROWS+1))
  block="$blockY;$blockX"

  printf '\e[%sH\e[41m \e[m' "$block"
}

game_over(){
  for _ in 1 7; do
    printf '\e[%sH\e[3D\e[3%dmGAME OVER\e[m' "$CENTER" "$_"
    sleep .1
  done
}

status_bar(){
  printf '\e[999H\e[2K\e[1;32mSNAKE\e[m x:%d y:%d len:%d spe:%d' \
    "$1" "$2" "$3" "$4"
}

end(){ stty echo; printf '\e[?1049l\e[?25h'; exit "$1"; }

len=3

init_term
for((;;)){
  status_bar "$snakeX" "$snakeY" "$len" "$speed"

  read_keys "${speed:=20}"
  case ${KEY:-L} in
    Q) end 0;;
    H|A|\[D) [[ $dir == H ]]&& continue; ((snakeX--))&& dir=L;;
    J|S|\[B) [[ $dir == J ]]&& continue; ((snakeY++))&& dir=K;;
    K|W|\[A) [[ $dir == K ]]&& continue; ((snakeY--))&& dir=J;;
    L|D|\[C) [[ $dir == L ]]&& continue; ((snakeX++))&& dir=H;;
    *) continue;;
  esac

  if (( snakeX < 1 )); then snakeX="$COLUMNS"
  elif (( snakeX > COLUMNS )); then snakeX=1
  elif (( snakeY < 1 )); then snakeY="$ROWS"
  elif (( snakeY > ROWS )); then snakeY=1
  fi

  snake+=("$snakeY;$snakeX")
  printf '\e[%sH\e[42m \e[m' "${snake[-1]}"

  if (( ${i:=0} >= len )); then
    printf '\e[%sH \e[m' "${snake[0]}"
    snake=("${snake[@]:1}")
    ((snakeBodyCount=${#snake[@]}-1))

    for _ in "${snake[@]::$snakeBodyCount}"; do
      [[ $_ == "$block" ]]&&{ (( speed ))&& ((speed--)); ((len++)); rand_block; }
      [[ $_ == "${snake[-1]}" ]]&&{ for _ in {0..5}; do game_over; done; end 1; }
    done
  else ((i++))
  fi
}

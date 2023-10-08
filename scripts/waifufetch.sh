#!/bin/sh
wget -q -U 'uwu' -O- "https://mywaifulist.moe/random" |\
    hxnormalize -x | hxextract -x "meta" - |\
    hxselect -s '\n' -i "::attr(content)" | grep -E '(jpeg|png|jpg)' |\
     head -1 | cut -d '"' -f2 | wget -q -O waifu.png -i-

#neofetch --backend kitty --source waifu.png
nsxiv waifu.png
rm waifu.png

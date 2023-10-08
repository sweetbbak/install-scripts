#!/bin/bash

# base64 -d <(cat output | jq '.data' | sed 's/\"//g') | play -t mp3 - 

# class="bold">English US
"en_us_001" # Female
"en_us_006" # Male 1
"en_us_007" # Male 2
"en_us_009" # Male 3
"en_us_010" # Male 4

# class="bold" # English UK
"en_uk_001" # Male 1
"en_uk_003" # Male 2

# class="bold" # English AU
"en_au_001" # Female
"en_au_002" # Male

# class="bold" # French
# "fr_001" # Male 1
# "fr_002" # Male 2

# class="bold" # German
# "de_001" # Female
# "de_002" # Male


# class="bold" # Spanish
# "es_002" # Male

# class="bold" # Spanish MX
# "es_mx_002" # Male

# class="bold" # Portuguese BR
# "br_001" # Female 1
# "br_003" # Female 2
# "br_004" # Female 3
# "br_005" # Male


# class="bold" # Indonesian
# "id_001" # Female


# class="bold" # Japanese
japanese=(
"jp_001" # Female 1
"jp_003" # Female 2
"jp_005" # Female 3
"jp_006" # Male
)

# class="bold" # Korean
korean=(
"kr_002" # Male 1
"kr_004" # Male 2
"kr_003" # Female
)

# class="bold" # Characters
characters=(
"en_us_ghostface" # Ghostface
"en_us_chewbacca" # Chewbacca
"en_us_c3po" # C3PO
"en_us_stitch" # Stitch
"en_us_stormtrooper"
"en_us_rocket" # Rocket
)

singing=(
"en_female_f08_salut_damour" # Alto
"en_male_m03_lobby" # Tenor
"en_male_m03_sunshine_soon" # Sunshine Soon
"en_female_f08_warmy_breeze" # Warmy Breeze
"en_female_ht_f08_glorious" # Glorious
"en_male_sing_funny_it_goes_up" # Up
"en_male_m2_xhxs_m03_silly" # Chipmunk
"en_female_ht_f08_wonderful_world" # Dramatic
)

curl 'https://tiktok-tts.weilnet.workers.dev/api/generation' --compressed \
-X POST -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/114.0' \
-H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' \
-H 'Content-Type: application/json' -H 'Origin: https://weilbyte.github.io' -H 'Connection: keep-alive' \
-H 'Referer: https://weilbyte.github.io/' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' \
-H 'Sec-Fetch-Site: cross-site' -H 'DNT: 1' -H 'Sec-GPC: 1' -H 'TE: trailers' \
--data-raw '{"text":"Hello, How are you doing?","voice":"en_us_001"}'

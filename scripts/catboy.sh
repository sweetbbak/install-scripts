#!/bin/bash
# uses catboy api to get catboy pics and stuff :3
output_dir="$HOME/Pictures/catboys"

[ ! -d "$output_dir" ] && {
    mkdir -p "$output_dir"
}

BASE="https://api.catboys.com"
declare -x icat
icat="kitty +kitten icat"

ping() {
    # returns ping with catboy phrases
    end="/ping"
    xh get "${BASE}${end}" | jq '.catboy_says, .error, .code'
}

img() {
    # image
    temp="$(mktemp)"
    end="/img"

    # save json
    xh get "${BASE}${end}" > "$temp"
    url="$(jq '.url' < "$temp")"
    # idk why but quoted urls dont work suddenly -_-
    url="${url//\"/}"
    title="${url##*/}"
    title="${title//\"/}"
    out="${output_dir}/${title}"

    if [ -z "$title" ]; then  
        printf '%s\n' "error with ${title}"
        exit 1
    fi
    
    curl -s $url --output $out

    [ -f "$out" ] && {
        kitty +kitten icat "$out"
    }
    printf "%s\n" "$(jq '.artist, .artist_url, .source_url, .source_url' < "$temp")"
    rm "$temp"
}

baka() {
    # returns gif
    end="/baka"
    img="$(xh get "${BASE}${end}" | jq '.url')"
    kitty +kitten icat "$img"
}

8ball() {
    # returns 8ball image and saying
    temp="$(mktemp)"
    end="/8ball"
    xh get "${BASE}${end}" > "$temp"

    img="$(jq '.url' < "$temp" )"
    txt="$(jq '.response' < "$temp")"

    kitty +kitten icat "$img"
    printf "%s\n" "$txt"
    rm "$temp"
}

catboy() {
    # returns cute saying
    end="/catboy"
    res="$(xh get "${BASE}${end}" | jq '.response')"
    printf "%s\n" "$res"
}

endpoints() {
    # shows all endpoints /xxx
    xh get "${BASE}/endpoints"
}

img

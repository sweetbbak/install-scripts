#!/bin/bash
url="https://rss-to-json-serverless-api.vercel.app/api?feedURL="
reddit="http://www.reddit.com"

subs=(
    news
    me_irl
    WhitePeopleTwitter
    ProgrammerHumor
    lostgeneration
    Chainsawfolk
    programming
    traaaaaaannnnnnnnnns
    manga
    ChurchofBelly
    196
    linux
    evangelion
    unixporn
)

case "$1" in
    -h)
    printf "%s\n" "$0 -r or --reddit with a reddit name, or use interactively"
    ;;
    -r)
        choice="$1"
    ;;
    *)
        choice="$(gum choose "${subs[@]}")"
    ;;
esac

choice="${choice//\"/}"
choice="${url}${reddit}/r/${choice}/.rss"

# temp="$(mktemp)"
xh get "${choice}" 

# pic="$(jq '.url' < "$temp")"
# title="${pic##*/}"
# title="${title//\"/}"
# pic="${pic//\"/}"
# # pic="$(echo "$pic" | sed 's/\"//g')"
# out="${dir}/${title}"

# curl -s "$pic" --output $out
# kitty +kitten icat "$out"

# [ -f "$temp" ] && {
#     rm "$temp"
# }


# Front page: http://www.reddit.com/.rss
# A subreddit: http://www.reddit.com/r/news/.rss
# A user: http://www.reddit.com/user/alienth/.rss
# A multireddit: http://www.reddit.com/r/news+wtf.rss (note that the slash is optional).
# The comments on a specific reddit post: http://www.reddit.com/r/technology/comments/1uc9ro/wearing_a_mind_controlled_exoskeleton_a_paralyzed/.rss
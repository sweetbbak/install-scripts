#! /bin/bash

export find_cmd='@bash -c "run_find %1 %2 %3 %4 %5"'

export fts=$(mktemp -u --tmpdir find-ts.XXXXXXXX)
export fpipe=$(mktemp -u --tmpdir find.XXXXXXXX)
mkfifo "$fpipe"

trap "rm -f $fpipe $fts" EXIT

fkey=$(($RANDOM * $$))

function run_find
{
    echo "6:@disabled@"
    if [[ $2 != TRUE ]]; then
        ARGS="-name '$1'"
    else
        ARGS="-regex '$1'"
    fi
    if [[ -n "$4" ]]; then
        touch -d "$4" $fts
        ARGS+=" -newer $fts"
    fi
    if [[ -n "$5" ]]; then
        ARGS+=" -exec grep -q -E '$5' {} \;"
    fi
    ARGS+=" -printf '%p\n%s\n%M\n%TD %TH:%TM\n%u/%g\n'"
    echo -e '\f' >> "$fpipe"
    eval find "$3" $ARGS >> "$fpipe"
    echo "6:$find_cmd"
}
export -f run_find

exec 3<> $fpipe

yad --plug="$fkey" --tabnum=1 --date-format="%Y-%m-%d" \
    --form --field="Name" '*' --field="Use regex:chk" 'no' \
    --field="Directory:dir" './' --field="Newer than:dt" '' \
    --field="Content" '' --field="yad-search:fbtn" "$find_cmd" &

yad --plug="$fkey" --tabnum=2 --list --no-markup --dclick-action="xdg-open '%s'" \
    --text "Search results:" --column="Name" --column="Size:sz" --column="Perms" \
    --column="Date" --column="Owner" --search-column=1 --expand-column=1 <&3 &

yad --paned --key="$fkey" --button="yad-close:1" --width=700 --height=500 \
    --title="Find files" --window-icon="system-search"

exec 3>&-

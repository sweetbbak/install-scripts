#!/bin/bash

exiftool -P -d "%Y%m%d" \
   "-filename<${FileModifyDate;}.%e" \
        "-filename<${GPSDateTime;}.%e" \
        "-filename<${MediaCreateDate;}.%e" \
        "-filename<${ModifyDate;}.%e" \
        "-filename<${DateTimeOriginal;}.%e" \
        "$1"

#!/bin/bash

# attempt at using the discord api to get manhwa updates
# to refresh the curl request open the link in a browser
# and look for the request that says "messages?limit=50"
# and right click + copy as curl and add --compressed

declare asura
asura=/tmp/asuras_discord
touch "$asura"

get_asura() {
    curl --compressed 'https://discord.com/api/v9/channels/977462074005413948/messages?limit=50' \
        -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/111.0' \
        -H 'Accept: */*' \
        -H 'Accept-Language: en-US,en;q=0.5' \
        -H 'Accept-Encoding: gzip, deflate, br' \
        -H 'Authorization: Njc4MTQ0NDM4NTU5NTcxOTc4.GUopQN.DPDw7VW6GR73fBPyW-rSdZttwjL-ynsUXmmtt0' \
        -H 'X-Super-Properties: eyJvcyI6IkxpbnV4IiwiYnJvd3NlciI6IkZpcmVmb3giLCJkZXZpY2UiOiIiLCJzeXN0ZW1fbG9jYWxlIjoiZW4tVVMiLCJicm93c2VyX3VzZXJfYWdlbnQiOiJNb3ppbGxhLzUuMCAoWDExOyBMaW51eCB4ODZfNjQ7IHJ2OjEwOS4wKSBHZWNrby8yMDEwMDEwMSBGaXJlZm94LzExMS4wIiwiYnJvd3Nlcl92ZXJzaW9uIjoiMTExLjAiLCJvc192ZXJzaW9uIjoiIiwicmVmZXJyZXIiOiJodHRwczovL2h5cHJsYW5kLm9yZy8iLCJyZWZlcnJpbmdfZG9tYWluIjoiaHlwcmxhbmQub3JnIiwicmVmZXJyZXJfY3VycmVudCI6IiIsInJlZmVycmluZ19kb21haW5fY3VycmVudCI6IiIsInJlbGVhc2VfY2hhbm5lbCI6InN0YWJsZSIsImNsaWVudF9idWlsZF9udW1iZXIiOjE4MzgxMywiY2xpZW50X2V2ZW50X3NvdXJjZSI6bnVsbCwiZGVzaWduX2lkIjowfQ=='\
        -H 'X-Discord-Locale: en-US' -H 'X-Debug-Options: bugReporterEnabled' \
        -H 'Alt-Used: discord.com' -H 'Connection: keep-alive' \
        -H 'Referer: https://discord.com/channels/977460544485359616/977462074005413948' \
        -H 'Cookie: OptanonConsent=isIABGlobal=false&datestamp=Sat+Mar+25+2023+20%3A16%3A26+GMT-0800+(Alaska+Daylight+Time)&version=6.33.0&hosts=&landingPath=https%3A%2F%2Fdiscord.com%2F&groups=C0001%3A1%2CC0002%3A1%2CC0003%3A1; __dcfduid=e393a4809c6411ed948875f3924ee7af; __sdcfduid=e393a4819c6411ed948875f3924ee7af362d7c5ad69de7d06a688a6e453581b94f14d3779880df01baec04d8aef187c8; __cfruid=3ed82c551143b9cfaeee1be93c0ae05c2a294d88-1679804185; locale=en-US; __cf_bm=q7RMCKksKVCSVMSVeBevz4KwvJkLE3qPNtqYfgYUNDo-1679804186-0-ASeN9ShY3mA5XrG3CX9cy8F0+HGDr8aBByzYSgF9KvTRrVlA7ux9I/MZ30qROrf1sGpV2e9rqDAwUt34lxoZc2/+q7FaMkgr7QB5p+2h4ggW3ib8lgg2zblRqvQSC7OH6g==' \
        -H 'Sec-Fetch-Dest: empty' \
        -H 'Sec-Fetch-Mode: cors' \
        -H 'Sec-Fetch-Site: same-origin' \
        -H 'TE: trailers' > "$asura"
}

get_asura
"$asura" < jq '.'
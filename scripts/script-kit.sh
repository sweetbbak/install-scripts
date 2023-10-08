#!/bin/sh

# Unix shell script kit.
#
# Unix shell script kit is a collection of utility functions and constants.
#
# The kit works with POSIX shells, including bash, zsh, dash, ksh, sh, etc.
#
# All suggestions are welcome and appreciated.
#
# ## Download
#
# Download the kit as one file that has everything:
#
# ```sh
# curl -O "https://raw.githubusercontent.com/SixArm/unix-shell-script-kit/main/unix-shell-script-kit"
# ```
#
# ## Source
#
# To use the kit in your own script, you source the kit like this:
#
# ```sh
# . /your/path/here/unix-shell-script-kit
# ```
#
# To use the kit in your own script, in the same directory, you source the kit like this:
#
# ```sh
# . "$(dirname "$(readlink -f "$0")")/unix-shell-script-kit"
# ```
#
# ## Tracking
#
#   * Package: unix-shell-script-kit
#   * Version: 12.0.0
#   * Created: 2017-08-22T00:00:00Z
#   * Updated: 2023-04-04T23:36:31Z
#   * License: GPL-2.0 or GPL-3.0 or contact us for more
#   * Website: https://github.com/sixarm/unix-shell-script-kit
#   * Contact: Joel Parker Henderson (joel@sixarm.com)

##
# Exit codes
##

# Our POSIX shell programs call "exit" with an exit code value.
#
# Conventions:
#
# * 0 = success, and non-zero indicates any other issue.
#
# * 1 = failure
#
# * 2 = failure due to a usage problem
#
# * 3-63 are for a program-specific exit codes.
#
# * 64-78 are based on BSD sysexits <https://man.openbsd.org/sysexits.3>
#
# * 80-119 are SixArm conventions that we find useful in many programs.
#
# Many shells use exit codes 126-128 to signal specific error status:
#
# * 126 is for the shell and indicates command found but is not executable.
#
# * 127 is for the shell and indicate command not found.
#
# * 128 is for invalid argument to exit.
#
# Many shells use exit codes above 128 in their $? representation of the exit
# status to encode the signal number of a process being killed.
#
# * 128+n means fatal error signal "n"
#
# * Example: 130 means terminated by ctrl-C (because ctrl-c is signal 2)
#
# * Example: 137 means terminated by kill -9 (because 128 + 9 = 137)
#
# Finally, the highest exit code:
#
# * 255 Exit status out of range (exit takes integer args 0-255)
#
# Be aware that on some shells, ut of range exit values can result in unexpected
# exit codes. An exit value greater than 255 returns an exit code modulo 256.
#
# * Example: exit 257 becomes exit 1 (because 257 % 256 = 1)
#
# * Caution: exit 256 becomes exit 0, which probably isn't what you want.
#
# For some typical needs that we encounter, we can suggest these:
#
# * Authentication issues: exit $EXIT_NOUSER
#
# * Authorization issues: exit $EXIT_NOPERM
#
# * A user chooses cancel: exit $EXIT_QUIT
#
# The exit code list below is subject to change over time, as we learn more.

# Success
#
# The program succeeded.
#
# E.g. everything worked as expected; any pipe processing will continue.
#
# Exit 0 meaning success is a widespread convention as a catch-all code.
#
EXIT_SUCCESS=0

# Failure
#
# The program failed.
#
# E.g. an error, an abort, found no results, lack of data, etc.
#
# Exit 1 meaning failure is a widespread convention as a catch-all code.
EXIT_FAILURE=1

# Usage
#
# The program usage is incorrect, or malformed, or in conflict, etc.
#
# E.g. wrong number of args, a bad flag, a syntax error in an option, etc.
#
# Exit 2 meaning usage is a widespread convention as a catch-all CLI code.
#
EXIT_USAGE=2

# Data Err
#
# The input data was incorrect in some way.
#
# This should only be used for user's data and not system files.
#
EXIT_DATAERR=65

# No Input
#
# An input file-- not a system file-- did not exist or was not readable.
#
# This could include errors like "No message" to a mailer, if it cared about it.
#
EXIT_NOINPUT=66

# No User
#
# The user specified did not exist.
#
# E.g. for email addresses, or remote logins, or authentication issues, etc.
#
EXIT_NOUSER=67

# No Host
#
# The host specified did not exist.
#
# E.g. for email addresses, or network requests, or webs links, etc.
#
EXIT_NOHOST=68

# Unavailable
#
# A service is unavailable.
#
# E.g. a support program or file does not exist. This can also be a catchall
# message when something does not work, but you do not know why.
#
EXIT_UNAVAILABLE=69

# Software
#
# An internal software error has been detected.
#
# This should be limited to non-operating system related errors as possible.
#
EXIT_SOFTWARE=70

# OS Err
#
# An operating system error has been detected.
#
# E.g. errors such as "cannot fork", "cannot create pipe", or getuid returns a
# user that does not exist in the passwd file, etc.
#
EXIT_OSERR=71

# OS File
#
# An operating system file (e.g. /etc/passwd) does not exist, or cannot
# be opened, or has some sort of error (e.g. syntax error).
#
EXIT_OSFILE=72

# Can't Create
#
# A user-specified output (e.g. a file) cannot be created.
#
EXIT_CANTCREATE=73

# IO Err
#
# An error occurred while doing input/output on some file, or stream, etc.
#
EXIT_IOERR=74

# Temp Fail
#
# A temporary failure occurred; this is not a permanent error.
#
# E.g. a mailer could not create a connection. The request can be retried later.
#
EXIT_TEMPFAIL=75

# Protocol
#
# The remote system returned something that was "not possible" during
# a protocol exchange.
#
EXIT_PROTOCOL=76

# No Perm
#
# You did not have sufficient permission to perform the operation.
#
# This is not for file system problems, which use EXIT_NOINPUT or
# EXIT_CANTCREATE, but for higher level permissions, authorizations, etc.
#
EXIT_NOPERM=77

# Config
#
# Something was found in an unconfigured or misconfigured state.
#
EXIT_CONFIG=78

# Exit codes 80-99 are for our own SixArm conventions.
# We propose these are generally useful to many kinds of programs.
#
# Caution: these exit codes and their values are work in progress,
# draft only, as a request for comments, in version 11.x of this file.
# These exit codes will be set in version 12.x when it's released.
#
# * 80+ for user interation issues
#
# * 90+ for access control issues
#
# * 100+: process runtime issues
#
# * 110+: expected ability issues

# Exit codes 80+ for user interation issues...

# Quit
#
# The user chose to quit, or cancel, or abort, or discontinue, etc.
#
EXIT_QUIT=80

# KYC (Know Your Customer)
#
# The program requires more user interaction, or user information, etc.
#
# E.g. email validation, age verification, terms of service agreement, etc.
#
EXIT_KYC=81

# Update
#
# The program or its dependencies need an update, or upgrade, etc.
#
EXIT_UPDATE=89

# Exit codes 90+ for access control issues...

# Conflict
#
# An item has a conflict e.g. edit collision, or merge error, etc.
#
# Akin to HTTP status code 409 Conflict.
#
EXIT_CONFLICT=90

# Unlawful
#
# Something is prohibited due to law, or warrant, or court order, etc.
#
# Akin to HTTP status code 451 Unavailable For Legal Reasons (RFC 7725).
#
EXIT_UNLAWFUL=91

# Payment Issue
#
# Something needs a credit card, or invoice, or billing, etc.
#
# Akin to a superset of HTTP status code 402 Payment Required.
#
EXIT_PAYMENT_ISSUE=92

# Quota Issue
#
# A quota is reached, such as exhausting a free trial, out of fuel, etc.
#
# Akin to a superset of HTTP status code 429 Too Many Requests.
#
EXIT_QUOTA_ISSUE=93

# Exit codes 100+ for process runtime issues...

# Busy
#
# A process is too busy, or overloaded, or throttled, or breakered, etc.
#
# Akin to HTTP status code 503 Service Unavailable; always means overloaded.
#
EXIT_BUSY=100

# Timeout
#
# A process is too slow, or estimated to take too long, etc.
#
# Akin to HTTP status code 408 Request Timeout.
#
EXIT_TIMEOUT=101

# Lockout
#
# A process is intentionally blocked as a danger, hazard, risk, etc.
#
# This is for lockout-tagout (LOTO) safety, or protecting users or data, etc.
#
EXIT_LOCKOUT=102

# Loop
#
# A process has detected an infinite loop, so is aborting.
#
# Akin to HTTP status code 508 Loop Detected.
#
EXIT_LOOP=103

# Exit codes 110+ for expected ability issues...

# Moved Permanently
#
# An expected ability has been moved permanently.
#
# Akin to HTTP status code 301 Moved Permanently.
#
EXIT_MOVED_PERMANENTLY=110

# Moved Temporarily
#
# An expected ability has been moved temporarily.
#
# Akin to HTTP status code 302 Moved Temporarily.
#
EXIT_MOVED_TEMPORARILY=111

# Gone
#
# An expected ability has been intentionally removed, or deleted, etc.
#
# Akin to HTTP status code 410 Gone; the ability should be purged.
#
EXIT_GONE=112

# Future
#
# An expected ability is not yet implemented, or work in progress, etc.
#
# Akin to HTTP status code 501 Not Implemented; implies future availability.
#
EXIT_FUTURE=119

# Exit code 125 for git...

# Git bisect skip
#
# The special exit code 125 should be used when the current source code cannot
# be tested. If the script exits with this code, the current revision will be
# skipped (see git bisect skip above).
#
# Value 125 was chosen as the highest sensible value to use for this
# purpose, because 126 and 127 are used by shells to signal specific errors.
#
EXIT_GIT_BISECT_SKIP=125

# Exit codes 126-127 for shell conventions...

# Command found but not executable
#
# A command is found but is not executable.
#
EXIT_COMMAND_FOUND_BUT_NOT_EXECUTABLE=126

# Command not found
#
# A command is not found.
#
EXIT_COMMAND_NOT_FOUND=127

# Exit code invalid
#
# The exit code is invalid.
#
# Compare EXIT_CODE_OUT_OF_RANGE=255
#
EXIT_CODE_INVALID=128

# Exit code out of range
#
# The exit code is out of range i.e. not in 0-255.
#
# Compare EXIT_CODE_INVALID=128
#
EXIT_CODE_INVALID=128

##
# Input/output helpers
##

# out: print output message to stdout.
#
# Example:
# ```
# out "my message"
# => my message
# ```
#
# We use `printf` instead of `echo` because `printf` is more consistent
# on more systems, such a for escape sequence handling.
#
# Compare:
#
#   * Use the `out` function to print to STDOUT.
#
#   * Use the `err` function to print to STDERR.
#
out() {
        printf %s\\n "$*"
}

# err: print error message to stderr.
#
# Example:
# ```
# err "my message"
# STDERR=> my message
# ````
#
# We use `printf` instead of `echo` because `printf` is more consistent
# on more systems, such a for escape sequence handling.
#
# Compare:
#
#   * Use the `out` function to print to STDOUT.
#
#   * Use the `err` function to print to STDERR.
#
err() {
        >&2 printf %s\\n "$*"
}

# die: print error message to stderr, then exit with error code.
#
# Example:
# ```
# die 1 "my message"
# STDERR=> my message
# => exit 1
# ```
die() {
        n="$1" ; shift ; >&2 printf %s\\n "$*" ; exit "$n"
}

# big: print a big banner to stdout, good for human readability.
#
# Example:
# ```
# big "my message"
# =>
# ###
# #
# # my message
# #
# ###
# ```
big() {
        printf \\n###\\n#\\n#\ %s\\n#\\n###\\n\\n "$*"
}

# log: print a datestamp, unique random id, hostname, process id, and message.
#
# Example:
# ```
# log "my message"
# => 2021-05-04T22:57:54.000000000+00:00 7e7151dc24bd511098ebb248771d8ffb abc.example.com 1234 my message
# ```
#
# We prefer this log file format for many of our scripts because we prefer
# logging the additional diagnositc information that we use for our systems:
# the datetime with nanosecond-friendly format and timezone-friendly format,
# unique random id a.k.a. zid, hostname, and process number.
#
log() {
        printf '%s %s %s %s\n' "$( now )" "$( zid )" "$( hostname )" $$ "$*"
}

# zid: generate a 32-bit secure random lowercase hex identifier.
#
# Example:
# ```
# zid
# => 78577554e967951388b5907854b4c337
# ```
zid() {
        hexdump -n 16 -v -e '16/1 "%02x" "\n"' /dev/random
}

# ask: prompt the user for a line of input, then return a trimmed string.
#
# Example:
# ```
# ask
# => prompt
# ```
ask() {
        read x ; echo "$x" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

##
# Date & time helpers
##

# now: get a datetime using our preferred ISO format.
#
# Example with the current datetime:
# ```
# now
# => 2021-05-04T22:59:28.769653000+00:00
# ```
#
# Example with a custom datetime, if your date command offers option -d:
# ```
# now -d "January 1, 2021"
# => 2021-01-01T00:00:00.000000000+00:00
# ```
#
# We prefer this date-time format for many of our scripts:
#
#   * We prefer ISO standard because it's well documented and supported.
#     Specifically, we use ISO "YYYY-MM-DDTHH:MM:SS.NNNNNNNNN+00:00".
#
#   * We prefer nanosecond width because it aligns with high-speed systems.
#     Specifically, we use GNU `date` and tools that print nanoseconds.
#
#   * We prefer timezone width because it aligns with localized systems.
#     Specifically, we use some systems and tools that require timezones.
#
# Note: the custom datetime capabilty relies on the system "date" command,
# because this script sends the args along to the system "date" command.
# For example Linux GNU "date" handles this, but macOS BSD "date" doesn't.
#
now() {
        # shellcheck disable=SC2120
        date -u "+%Y-%m-%dT%H:%M:%S.%N+00:00" "$@" | sed 's/N/000000000/'
}

# now_date: get a date using our preferred ISO format
#
# Example:
#
# ```sh
# now_date
# => 2021-05-04
# ```
#
# Example with a custom date, if your date command offers option -d:
# ```
# now_date -d "January 1, 2021"
# => 2021-01-01
# ```
#
now_date() {
        # shellcheck disable=SC2120
        date -u "+%Y-%m-%d" "$@"
}

# sec: get the current time in POSIX seconds.
#
# Example:
# ```
# sec
# => 1620169178
# ```
sec() {
        date "+%s" "$@"
}

# age: get the age of a given time in POSIX seconds.
#
# Example:
# ```
# age 1620169178
# => 19
# ```
age() {
        printf %s\\n "$(( $(date "+%s") - $1 ))"
}

# newer: is the age of a given time newer than a given number of seconds?
#
# Example:
# ```
# newer 2000000000 && echo "true" || echo "false
# => true
# ```
newer() {
        [ "$(( $(date "+%s") - $1 ))" -lt "$2" ]
}

# older: is the age of a given time older than a given number of seconds?
#
# Example:
# ```
# older 1000000000 && echo "true" || echo "false"
# => true
# ```
older() {
        [ "$(( $(date "+%s") - $1 ))" -gt "$2" ]
}

##
# Validation helpers
##

# command_exists: does a command exist?
#
# Example:
# ```
# command_exists grep
# => true
#
# command_exists curl
# => false
# ```
command_exists() {
        command -v "$1" >/dev/null 2>&1
}

# command_exists_or_die: ensure a command exists.
#
# Example:
# ```
# command_exists_or_die grep
# => true
#
# command_exists_or_die loremipsum
# STDERR=> Command needed: loremipsum
# => exit 1
# ```
command_exists_or_die() {
        command_exists "$1" || die "$EXIT_UNAVAILABLE" "Command needed: $1"
}

# command_version_exists_or_die: ensure a command version exists.
#
# Example:
# ```
# command_version_exists_or_die grep 2.2 1.1
# => true
#
# version_or_die grep 2.2 3.3
# STDERR=> Command version needed: grep >= 3.x
# => exit 1
# ```
command_version_exists_or_die() {
        command_exists "$1" && version "$2" "$3" || die "$EXIT_UNAVAILABLE" "Command version needed: $1 >= $2 (not ${3:-?})"
}

# var_exists: does a variable exist?
#
# Example:
# ```
# var_exists HOME
# => true
#
# var_exists FOO
# => false
# ```
var() {
        ! eval 'test -z ${'$1'+x}'
}

# var_exists_or_die: ensure a variable exists.
#
# Example:
# ```
# var_exists_or_die HOME
# => true
#
# var_exists_or_die FOO
# STDERR=> Variable needed: FOO
# => exit 1
# ```
var_exists_or_die() {
        var_exists "$1" || die "$EXIT_CONFIG" "Variable needed: $1"
}

# version: is a version sufficient?
#
# Example:
# ```
# version 1.1 2.2
# => true
#
# version 3.3 2.2
# => false
# ```
version() {
        [ "$(cmp_digits "$1" "$2")" -le 0 ]
}

# version_or_die: ensure a version is sufficient.
#
# Example:
# ```
# version_or_die 1.1 2.2
# => true
#
# version_or_die 3.3 2.2
# STDERR=> Version needed: >= 3.3 (not 2.2)
# ```
version_or_die() {
        version "$1" "$2" || die "$EXIT_CONFIG" "Version needed: >= $1 (not ${2:-?})"
}

##
# Number helpers
##

# int: convert a number string to an integer number string.
#
# Example:
# ```
# int 1.23
# => 1
# ```
int() {
        printf %s\\n "$1" | awk '{ print int($0); exit }'
}

# sum: print the sum of numbers.
#
# Example:
# ```
# sum 1 2 3
# => 6
# ```
sum() {
        awk '{for(i=1; i<=NF; i++) sum+=$i; } END {print sum}'
}

##
# Comparison helpers
##

# cmp_alnums: compare alnums as groups, such as for word version strings.
#
# Example:
#
# ```
# cmp_alnums "a.b.c" "a.b.c"
# => 0 (zero means left == right)
#
# cmp_alnums "a.b.c" "a.b.d"
# => -1 (negative one means left < right)
#
# cmp_alnums "a.b.d" "a.b.c"
# => 1 (positive one means left > right)
# ```
#
cmp_alnums() {
        if [ "$1" = "$2" ]; then
                echo "0"; return 0
        fi
	a=$(printf %s\\n "$1" | sed 's/^[^[:alnum:]]*//')
	b=$(printf %s\\n "$2" | sed 's/^[^[:alnum:]]*//')
	while true; do
		x=$(printf %s\\n "$a" | sed 's/[^[:alnum:]].*//')
		y=$(printf %s\\n "$b" | sed 's/[^[:alnum:]].*//')
		if [ "$x" = "" ] && [ "$y" = "" ]; then
			echo "0"; return 0
		fi
		if [ "$x" = "" ] || [ "$(expr "$x" \< "$y")" = 1 ]; then
			echo "-1"; return 0
		fi
		if [ "$y" = "" ] || [ "$(expr "$x" \> "$y")" = 1 ]; then
			echo "1"; return 0
		fi
		a=$(printf %s\\n "$a" | sed 's/^[[:alnum:]]*[^[:alnum:]]*//')
		b=$(printf %s\\n "$b" | sed 's/^[[:alnum:]]*[^[:alnum:]]*//')
	done
}

# cmp_digits: compare digits as groups, such as for numeric version strings.
#
# Example:
#
# ```
# cmp_digits 1.2.3 1.2.3
# => 0 (zero means left == right)
#
# cmp_digits 1.2.3 1.2.4
# => -1 (negative one means left < right)
#
# cmp_digits 1.2.4 1.2.3
# => 1 (positive one means left > right)
# ```
#
cmp_digits() {
        if [ "$1" = "$2" ]; then
                echo "0"; return 0
        fi
	a=$(printf %s\\n "$1" | sed 's/^[^[:digit:]]*//')
	b=$(printf %s\\n "$2" | sed 's/^[^[:digit:]]*//')
	while true; do
		x=$(printf %s\\n "$a" | sed 's/[^[:digit:]].*//')
		y=$(printf %s\\n "$b" | sed 's/[^[:digit:]].*//')
		if [ "$x" = "" ] && [ "$y" = "" ]; then
			echo "0"; return 0
		fi
		if [ "$x" = "" ] || [ $x -lt $y ]; then
			echo "-1"; return 0
		fi
		if [ "$y" = "" ] || [ $x -gt $y ]; then
			echo "1"; return 0
		fi
		a=$(printf %s\\n "$a" | sed 's/^[[:digit:]]*[^[:digit:]]*//')
		b=$(printf %s\\n "$b" | sed 's/^[[:digit:]]*[^[:digit:]]*//')
	done
}

##
# Extensibility helpers
##

# dot_all: source all the executable files in a given directory and subdirectories.
#
# Example:
# ```
# dot_all ~/temp
# => . ~/temp/a.sh
# => . ~/temp/b.pl
# => . ~/temp/c.js
# ```
dot_all() {
        find "${1:-.}" -type f \( -perm -u=x -o -perm -g=x -o -perm -o=x \) -exec test -x {} \; -exec . {} \;
}

# run_all: run all the executable commands in a given directory and subdirectories.
#
# Example:
# ```
# run_all ~/temp
# => ~/temp/a.sh
# => ~/temp/b.pl
# => ~/temp/c.js
# ```
run_all() {
        find "${1:-.}" -type f \( -perm -u=x -o -perm -g=x -o -perm -o=x \) -exec test -x {} \; -exec {} \;
}

# sh_all: shell all the executable commands in a given directory and subdirectories.
#
# Example:
# ```
# sh_all ~/temp
# => sh -c ~/temp/a.sh
# => sh -c ~/temp/b.pl
# => sh -c ~/temp/c.js
# ```
sh_all() {
        find "${1:-.}" -type f \( -perm -u=x -o -perm -g=x -o -perm -o=x \) -exec test -x {} \; -print0 | xargs -0I{} -n1 sh -c "{}"
}

# rm_all: remove all files in a given directory and subdirectories-- use with caution.
#
# Example:
# ```
# rm_all ~/temp
# => rm ~/temp/a.sh
# => rm ~/temp/b.pl
# => rm ~/temp/c.js
# ```
rm_all() {
        find "${1:-.}" -type f -exec rm {} \;
}

##
# Text helpers
##

# trim: remove any space characters at the text's start or finish.
#
# Example:
# ```
# trim "  foo  "
# => foo
#```
trim() {
        printf %s\\n "$*" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

# slug: convert a string from any characters to solely lowercase and single internal dash characters.
#
# Example:
# ```
# slug "**Foo** **Goo** **Hoo**"
# => foo-goo-hoo
#```
slug() {
        printf %s\\n "$*" | sed 's/[^[:alnum:]]/-/g; s/--*/-/g; s/^-*//; s/-*$//;' | tr '[[:upper:]]' '[[:lower:]]'
}

# slugs: convert a string from any characters to solely lowercase and single internal dash characters and slash characters.
#
# Example:
# ```
# slugs "**Foo** / **Goo** / **Hoo**"
# => foo/goo/hoo
#```
slugs(){
        printf %s\\n "$*" | sed 's/[^[:alnum:]\/]/-/g; s/--*/-/g; s/^-*//; s/-*$//; s/-*\/-*/\//g' | tr '[[:upper:]]' '[[:lower:]]'
}

# upper_format: convert text from any lowercase letters to uppercase letters.
#
# Example:
# ```
# upper_format AbCdEf
# => ABCDEF
#```
upper_format() {
        printf %s\\n "$*" | tr '[[:lower:]]' '[[:upper:]]'
}

# lower_format: convert text from any uppercase letters to lowercase letters.
#
# Example:
# ```
# lower_format AbCdEf
# => abcdef
#```
lower_format() {
        printf %s\\n "$*" | tr '[[:upper:]]' '[[:lower:]]'
}

# chain_format: convert a string from any characters to solely alphanumeric and single internal dash characters.
#
# Example:
# ```
# chain_format "**Foo** **Goo** **Hoo**"
# => Foo-Goo-Hoo
#```
chain_format() {
        printf %s\\n "$*" | sed 's/[^[:alnum:]]\{1,\}/-/g; s/-\{2,\}/-/g; s/^-\{1,\}//; s/-\{1,\}$//;'
}

# snake_format: convert a string from any characters to solely alphanumeric and single internal underscore characters.
#
# Example:
# ```
# snake_format "**Foo** **Goo** **Hoo**"
# => Foo_Goo_Hoo
#```
snake_format() {
        printf %s\\n "$*" | sed 's/[^[:alnum:]]\{1,\}/_/g; s/_\{2,\}/_/g; s/^_\{1,\}//; s/_\{1,\}$//;'
}

# space_format: convert a string from any characters to solely alphanumeric and single internal space characters.
#
# Example:
# ```
# space_format "**Foo** **Goo** **Hoo**"
# => Foo Goo Hoo
#```
space_format() {
        printf %s\\n "$*" | sed 's/[^[:alnum:]]\{1,\}/ /g; s/ \{2,\}/ /g; s/^ \{1,\}//; s/ \{1,\}$//;'
}

# touch_format: convert a string from any characters to solely a command "touch -t" timestamp format.
#
# Example:
# ```
# touch_format "Foo  2021-05-04 22:57:54 Goo"
# => 202105042257.54
#```
touch_format() {
        printf %s\\n "$*" | sed 's/[^[:digit:]]//g; s/^\([[:digit:]]\{12\}\)\([[:digit:]]\{2\}\)/\1.\2/;'
}

# select_character_class: get a string's characters that match a class, with optional offset and length.
#
# Syntax:
# ```
# select_character_class <string> <class> [offset [length]]
# ```
#
# Example with character class:
# ```
# select_character_class foo123goo456 alpha
# => foogoo
# ```
#
# Example with character class and substring offset:
# ```
# select_character_class foo123goo456 alpha 3
# => goo
# ```
#
# Example with character class and substring offset and length:
# ```
# select_character_class foo123goo456 alpha 3 1
# => g
# ```
select_character_class() {
	string=${1//[^[:$2:]]/}
	offset=${3:-0}
	length=${4:-${#string}}
	printf %s\\n ${string:$offset:$length}
}

# reject_character_class: get a string's characters that don't match a class, with optional offset and length.
#
# Syntax:
# ```
# reject_character_class <string> <class> [offset [length]]
# ```
#
# Example with character class:
# ```
# reject_character_class foo123goo456 alpha
# => -123--456
# ```
#
# Example with character class and substring offset:
# ```
# reject_character_class foo123goo456 alpha 6
# => 456
# ```
#
# Example with character class and substring offset and length:
# ```
# reject_character_class foo123goo456 alpha 6 1
# => 4
# ```
reject_character_class() {
	string=${1//[[:$2:]]/}
	offset=${3:-0}
	length=${4:-${#string}}
	printf %s\\n ${string:$offset:$length}
}

##
# Random character helpers
##

# random_char
#
# Syntax:
# ```
# random_char [characters [length]]
# ```
#
# Example:
# ```
# random_char ABCDEF 8
# => CBACBFDD
#```
#
# Example hexadecimal digit uppercase:
# ```
# random_char 0-9A-F 8
# => FC56A95C
#```
#
# Example character class for uppercase letters:
# ```
# random_char '[:upper:]' 8
# => ZMGIQBJB
#```
#
# POSiX character classes for ASCII characters:
#
# ```
# Class       Pattern        Description
# ----------  -------------  -----------
# [:upper:]   [A-Z]          uppercase letters
# [:lower:]   [a-z]          lowercase letters
# [:alpha:]   [A-Za-z]       uppercase letters and lowercase letters
# [:alnum:]   [A-Za-z0-9]    uppercase letters and lowercase letters and digits
# [:digit:]   [0-9]          digits
# [:xdigit:]  [0-9A-Fa-f]    hexadecimal digits
# [:punct:]                  punctuation (all graphic characters except letters and digits)
# [:blank:]   [ \t]          space and TAB characters only
# [:space:]   [ \t\n\r\f\v]  whitespace characters (space, tab, newline, return, feed, vtab)
# [:cntrl:]                  control characters
# [:graph:]   [^ [:cntrl:]]  graphic characters (all characters which have graphic representation)
# [:print:]   [[:graph:] ]   graphic characters and space
# ```
random_char() {
        chars=${1:-'[:graph:]'}
        len=${2-1}
        printf "%s\n" $(LC_ALL=C < /dev/urandom tr -dc "$chars" | head -c"$len")
}

# random_char_alnum: random characters using [:alnum:] class.
#
# Syntax:
# ```
# random_char_alnum [length]
# ```
#
# Example:
# ```
# random_char_alnum 8
# => 1Yp7M7wc
#```
random_char_alnum() {
        random_char '[:alnum:]' "$@"
}

# random_char_alpha: random characters using [:alpha:] class.
#
# Syntax:
# ```
# random_char_alnum [length]
# ```
#
# Example:
# ```
# random_char_alpha 8
# => dDSmQlYD
#```
random_char_alpha() {
        random_char '[:alpha:]' "$@"
}

# random_char_blank: random characters using [:blank:] class.
#
# Syntax:
# ```
# random_char_alnum [length]
# ```
#
# Example:
# ```
# random_char_blank 8
# => "  \t  \t  \t"
#```
random_char_blank() {
        random_char '[:blank:]' "$@"
}

# random_char_cntrl: random characters using [:cntrl:] class.
#
# Syntax:
# ```
# random_char_alnum [length]
# ```
#
# Example:
# ```
# random_char_cntrl 8
# => "^c^m^r^z^a^e^p^u"
#```
random_char_cntrl() {
        random_char '[:cntrl:]' "$@"
}

# random_char_digit: random characters using [:digit:] class.
#
# Syntax:
# ```
# random_char_alnum [length]
# ```
#
# Example:
# ```
# random_char_digit 8
# => 36415110
#```
random_char_digit() {
        random_char '[:digit:]' "$@"
}

# random_char_graph: random characters using [:graph:] class.
#
# Syntax:
# ```
# random_char_alnum [length]
# ```
#
# Example:
# ```
# random_char_graph 8
# => e'2-3d+9
#```
random_char_graph() {
        random_char '[:graph:]' "$@"
}

# random_char_lower: random characters using [:lower:] class.
#
# Syntax:
# ```
# random_char_alnum [length]
# ```
#
# Example:
# ```
# random_char_lower 8
# => pgfqrefo
#```
random_char_lower() {
        random_char '[:lower:]' "$@"
}

# random_char_lower_digit: random characters using [:lower:][:digit] classes
#
# Syntax:
# ```
# random_char_alnum [length]
# ```
#
# Example:
# ```
# random_char_lower_digit 8
# => 69m7o83i
#```
random_char_lower_digit() {
        random_char '[:lower:][:digit:]' "$@"
}

# random_char_upper: random characters using [:upper:] class.
#
# Syntax:
# ```
# random_char_alnum [length]
# ```
#
# Example:
# ```
# random_char_upper 8
# => EGXUHNIM
#```
random_char_upper() {
        random_char '[:upper:]' "$@"
}

# random_char_upper_digit: random characters using [:upper:][:digit:] classes
#
# Syntax:
# ```
# random_char_alnum [length]
# ```
#
# Example:
# ```
# random_char_upper_digit 8
# => L2PT37H6
#```
random_char_upper_digit() {
        random_char '[:upper:][:digit:]' "$@"
}

# random_char_print: random characters using [:print:] class.
#
# Syntax:
# ```
# random_char_alnum [length]
# ```
#
# Example:
# ```
# random_char_print 8
# => ),zN87K;
#```
random_char_print() {
        random_char '[:print:]' "$@"
}

# random_char_space: random characters using [:space:] class.
#
# Syntax:
# ```
# random_char_alnum [length]
# ```
#
# Example:
# ```
# random_char_space 8
# => "\n \t\r \v \f"
#```
random_char_space() {
        random_char '[:space:]' "$@"
}

# random_char_xdigit: random characters using [:xdigit:] class.
#
# Syntax:
# ```
# random_char_alnum [length]
# ```
#
# Example:
# ```
# random_char_xdigit 8
# => eC3Ce9eD
#```
random_char_xdigit() {
        random_char '[:xdigit:]' "$@"
}

##
# Array helpers
##

# array_n: get the array number of fields a.k.a. length a.k.a. size.
#
# Example:
# ```
# set -- a b c d
# array_n "$@"
# => 4
# ```
array_n() {
        printf %s "$#"
}

# array_i: get the array item at index `i` which is 1-based.
#
# Example:
# ```
# set -- a b c d
# array_i "$@" 3
# => c
# ```
#
# POSIX syntax uses an array index that starts at 1.
#
# Bash syntax uses an array index that starts at 0.
#
# Bash syntax can have more power this way if you prefer it:
#
# ```
# [ $# == 3 ] && awk -F "$2" "{print \$$3}" <<< "$1" || awk "{print \$$2}" <<< "$1"
# ```
array_i() {
        for __array_i_i in "$@"; do true; done
        if [ "$__array_i_i" -ge 1 -a "$__array_i_i" -lt $# ]; then
                __array_i_j=1
                for __array_i_x in "$@"; do
                        if [ "$__array_i_j" -eq "$__array_i_i" ]; then
                                printf %s "$__array_i_x"
                                return
                        fi
                        __array_i_j=$((__array_i_j+1))
                done
        fi
        exit $EXIT_USAGE
}

# array_first: get the array's first item.
#
# Example:
# ```
# set -- a b c d
# array_first "$@"
# => a
# ```
array_first() {
        printf %s "$1"
}

# array_last: get the array's last item.
#
# Example:
# ```
# set -- a b c d
# array_last "$@"
# => d
# ```
array_last() {
        for __array_last_x in "$@"; do true; done
        printf %s "$__array_last_x"
}

# array_car: get the array's car item a.k.a. first item.
#
# Example:
# ```
# set -- a b c d
# array_car "$@"
# => a
# ```
array_car() {
        printf %s "$1"
}

# array_cdr: get the array's cdr items a.k.a. everything after the first item.
#
# Example:
# ```
# set -- a b c
# array_cdr "$@"
# => b c d
# ```
array_cdr() {
        shift
        printf %s "$*"
}

##
# Assert helpers
##

# assert_test: assert a test utility command succeeds.
#
# Example:
# ```
# assert_test -x program.sh
# => success i.e. no output
#
# assert_test -x notes.txt
# STDERR=> assert_test -x notes.txt
# ```
assert_test() {
        test "$1" "$2" || err assert_test "$@"
}

# assert_empty: assert an item is empty.
#
# Example:
# ```
# assert_empty ""
# => success i.e. no output
#
# assert_empty foo
# STDERR=> assert_empty foo
# ```
assert_empty() {
        [ -z "$1" ] || err assert_empty "$@"
}

# assert_not_empty: assert an item is not empty.
#
# Example:
# ```
# assert_not_empty foo
# => success i.e. no output
#
# assert_not_empty ""
# STDERR=> assert_not_empty
# ```
assert_not_empty() {
        [ -z "$1" ] || err assert_empty "$@"
}

# assert_int_eq: assert an integer is equal to another integer.
#
# Example:
# ```
# assert_int_eq 1 1
# => success i.e. no output
#
# assert_int_eq 1 2
# STDERR=> assert_int_eq 1 2
# ```
assert_int_eq() {
        [ "$1" -eq "$2" ] || err assert_int_eq "$@"
}

# assert_int_ne: assert an integer is not equal to another integer.
#
# Example:
# ```
# assert_int_eq 1 2
# => success i.e. no output
#
# assert_int_eq 1 1
# STDERR=> assert_int_ne 1 1
# ```
assert_int_ne() {
        [ "$1" -ne "$2" ] || err assert_int_equal "$@"
}

# assert_int_ge: assert an integer is greater than or equal to another integer.
#
# Example:
# ```
# assert_int_ge 2 1
# => success i.e. no output
#
# assert_int_ge 1 2
# STDERR=> assert_int_ge 1 2
# ```
assert_int_ge() {
        [ "$1" -ge "$2" ] || err assert_int_ge "$@"
}

# assert_int_gt: assert an integer is greater than another integer.
#
# Example:
# ```
# assert_int_gt 2 1
# => success i.e. no output
#
# assert_int_gt 1 2
# STDERR=> assert_int_gt 1 2
# ```
assert_int_gt() {
        [ "$1" -gt "$2" ] || err assert_int_gt "$@"
}

# assert_int_le: assert an integer is less than or equal to another integer.
#
# Example:
# ```
# assert_int_le 1 2
# => success i.e. no output
#
# assert_int_le 2 1
# STDERR=> assert_int_le 2 1
# ```
assert_int_le() {
        [ "$1" -le "$2" ] || err assert_int_le "$@"
}

# assert_int_lt: assert an integer is less than to another integer.
#
# Example:
# ```
# assert_int_lt 1 2
# => success i.e. no output
#
# assert_int_lt 2 1
# STDERR=> assert_int_lt 2 1
# ```
assert_int_lt() {
        [ "$1" -lt "$2" ] || err assert_int_lt "$@"
}

# assert_str_eq: assert a string is equal to another string.
#
# Example:
# ```
# assert_str_eq 1 1
# => success i.e. no output
#
# assert_str_eq 1 2
# STDERR=> assert_str_eq 1 2
# ```
assert_str_eq() {
        [ "$1" -eq "$2" ] || err assert_str_eq "$@"
}

# assert_str_ne: assert a string is not equal to another string.
#
# Example:
# ```
# assert_str_eq 1 2
# => success i.e. no output
#
# assert_str_eq 1 1
# STDERR=> assert_str_ne 1 1
# ```
assert_str_ne() {
        [ "$1" -ne "$2" ] || err assert_str_equal "$@"
}

# assert_str_ge: assert a string is greater than or equal to another string.
#
# Example:
# ```
# assert_str_ge 2 1
# => success i.e. no output
#
# assert_str_ge 1 2
# STDERR=> assert_str_ge 1 2
# ```
assert_str_ge() {
        [ "$1" -ge "$2" ] || err assert_str_ge "$@"
}

# assert_str_gt: assert a string is greater than another string.
#
# Example:
# ```
# assert_str_gt 2 1
# => success i.e. no output
#
# assert_str_gt 1 2
# STDERR=> assert_str_gt 1 2
# ```
assert_str_gt() {
        [ "$1" -gt "$2" ] || err assert_str_gt "$@"
}

# assert_str_le: assert a string is less than or equal to another string.
#
# Example:
# ```
# assert_str_le 1 2
# => success i.e. no output
#
# assert_str_le 2 1
# STDERR=> assert_str_le 2 1
# ```
assert_str_le() {
        [ "$1" -le "$2" ] || err assert_str_le "$@"
}

# assert_str_lt: assert a string is less than to another string.
#
# Example:
# ```
# assert_str_lt 1 2
# => success i.e. no output
#
# assert_str_lt 2 1
# STDERR=> assert_str_lt 2 1
# ```
assert_str_lt() {
        [ "$1" -lt "$2" ] || err assert_str_lt "$@"
}

# assert_str_starts_with: assert a string starts with a substring.
#
# Example:
# ```
# assert_str_starts_with foobar foo
# => success i.e. no output
#
# assert_str_starts_with foobar xxx
# STDERR=> assert_str_starts_with foobar xxx
# ```
assert_str_starts_with() {
        [ "$1" != "${1#"$2"}" ] || err assert_str_starts_with "$@"
}

# assert_str_ends_with: assert a string ends with with a substring.
#
# Example:
# ```
# assert_str_ends_with foobar bar
# => success i.e. no output
#
# assert_str_ends_with foobar xxx
# STDERR=> assert_str_ends_with foobar xxx
# ```
assert_str_ends_with() {
        [ "$1" != "${1%"$2"}" ] || err assert_str_ends_with "$@"
}

##
# Make temp helpers
##

# mktemp_dir: make a temporary directory path.
#
# Example:
# ```
# mktemp_dir
# => /var/folders/4f7b65122b0fb65b0fdad568a65dc97d
# ```
mktemp_dir() {
        x=$(mktemp -d -t "${1:-$(zid)}") ; trap '{ rm -rf "$x"; }' EXIT ; out "$x"
}

# mktemp_file: make a temporary file path.
#
# Example:
# ```
# mktemp_file
# => /var/folders/4f7b65122b0fb65b0fdad568a65dc97d/1d9aafac5373be95d8b4c2dece0b1197
# ```
mktemp_file() {
        x=$(mktemp -t "${1:-$(zid)}") ; trap '{ rm -f "$x"; }' EXIT ; out "$x"
}

##
# Media helpers
##

# file_media_type: get a file's media type a.k.a. mime type such as "text/plain".
#
# Example:
# ```
# file_media_type notes.txt
# => text/plain
# ```
file_media_type() {
        file --brief --mime "$1"
}

# file_media_type_supertype: get a file's media type type a.k.a. mime type such as "text".
#
# Example:
# ```
# file_media_type_supertype notes.txt
# => text
# ```
file_media_type_supertype() {
        file --brief --mime "$1" | sed 's#/.*##'
}

# file_media_type_subtype: get a file's media type subtype a.k.a. mime type such as "plain".
#
# Example:
# ```
# file_media_type_subtype notes.txt
# => plain
# ```
file_media_type_subtype() {
        file --brief --mime "$1" | sed 's#^[^/]*/##; s#;.*##'
}

##
# Font helpers
##

# font_name_exists: does a font name exist on this system?
#
# Example:
# ```
# font_name_exists Arial
# => true
#
# font_name_exists Foo
# => false
# ```
#
font_name_exists() {
        fc-list | grep -q ": $1:"
}

# font_name_exists_or_die: ensure a font name exists.
#
# Example:
# ```
# font_name_exists_or_die Arial
# => true
#
# font_name_exists_or_die Foo
# STDERR=> Font needed: Foo
# => exit 1
# ```
#
font_name_exists_or_die() {
        font_name_exists "$1" || die "$EXIT_UNAVAILABLE" "Font needed: $1"
}

##
# Content helpers
##

# file_ends_with_newline: Does a file end with a newline?
#
# Example:
# ```
# file_ends_with_newline notes.txt
# => true
# ```
file_ends_with_newline() {
        test $(tail -c1 "$1" | wc -l) -gt 0
}


##
# Directory helpers
##

# user_dir: get a user-specific directory via env var, or XDG setting, or HOME.
#
# Example:
# ```
# user_dir foo => $FOO_DIR || $FOO_HOME || $XDG_FOO_DIR || $XDG_FOO_HOME || $HOME/foo
# ```
#
# Conventions:
#
#   * `user_dir bin` => binary executable directory
#   * `user_dir cache` => cache directory
#   * `user_dir config` => configuration directory
#   * `user_dir data` => data directory
#   * `user_dir desktop` => desktop directory
#   * `user_dir documents` => documents directory
#   * `user_dir download` => download directory
#   * `user_dir log` => logging directory
#   * `user_dir music` => music directory
#   * `user_dir pictures` => pictures directory
#   * `user_dir publicshare` => public share directory
#   * `user_dir runtime` => runtime directory
#   * `user_dir state` => state directory
#   * `user_dir temp` => temporary directory
#   * `user_dir templates` => templates directory
#   * `user_dir videos` => videos directory
#
# Popular XDG conventions:
#
#   * `XDG_DESKTOP_DIR` => user-specific desktop, such as frequent apps and files.
#   * `XDG_DOCUMENTS_DIR` => user-specific documents, such as typical working files.
#   * `XDG_DOWNLOAD_DIR` => user-specific downloads, such as internet file downloads.
#   * `XDG_MUSIC_DIR` => user-specific music files, such as songs.
#   * `XDG_PICTURES_DIR` => user-specific pictures, such as photos.
#   * `XDG_PUBLICSHARE_DIR` => user-specific public share, such as file sharing.
#   * `XDG_TEMPLATES_DIR` => user-specific templates.
#   * `XDG_VIDEOS_DIR` => user-specific videos, such as movies.
#
# POSIX XDG conventions:
#
#   * `XDG_BIN_HOME` => user-specific binaries, analogous to system /usr/bin or $HOME/.local/bin.
#   * `XDG_LOG_HOME` => user-specific log files, analogous to system /var/log or $HOME/.local/log.
#   * `XDG_TEMP_HOME` => user-specific temporary files, analogous to system /temp or $HOME/.temp.
#   * `XDG_DATA_HOME` => user-specific data files, analogous to system /usr/share or $HOME/.local/share.
#   * `XDG_CACHE_HOME` => user-specific cache files, analogous to system /var/cache or $HOME/.cache.
#   * `XDG_STATE_HOME` => user-specific cache files, analogous to system /var/state or $HOME/.local/state.
#   * `XDG_CONFIG_HOME` => user-specific configuration files, analogous to system /etc or $HOME/.config.
#   * `XDG_RUNTIME_HOME` => user-specific runtime files such as sockets, named pipes, etc. or $HOME/.runtime.
#
# See also:
#
#   * https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
#
#   * https://wiki.archlinux.org/title/XDG_user_directories
#
user_dir(){
	upper=$(printf %s\\n "$1" | tr '[:lower:]' '[:upper:]')
	lower=$(printf %s\\n "$1" | tr '[:upper:]' '[:lower:]')
	a=$(eval printf "%s\\\\n" \$${upper}_DIR)
	b=$(eval printf "%s\\\\n" \$${upper}_HOME)
	c=$(eval printf "%s\\\\n" \$XDG_${upper}_DIR)
	d=$(eval printf "%s\\\\n" \$XDG_${upper}_HOME)
        printf %s\\n "${a:=${b:=${c:=${d:=$HOME/$lower}}}}"
}

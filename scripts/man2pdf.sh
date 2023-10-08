#!/usr/bin/env bash

# Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([output],[o],[The output file])
# ARG_OPTIONAL_BOOLEAN([open-pdf],[],[Open the PDF file after creating it],[on])
# ARG_POSITIONAL_SINGLE([name-or-file])
# ARG_POSITIONAL_SINGLE([section],[],[""])
# ARG_DEFAULTS_POS([])
# ARG_HELP([<Open a man page as a PDF file>])
# ARG_VERSION([echo $(basename $0) 420.69])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.dev for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='ohv'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_name_or_file=
_arg_section=""
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_output=
_arg_open_pdf="on"


print_help()
{
	printf '%s\n' "<Open a man page as a PDF file>"
	printf 'Usage: %s [-o|--output <arg>] [--(no-)open-pdf] [-h|--help] [-v|--version] <name-or-file> [<section>]\n' "$(basename $0)"
	printf '\t%s\n' "-o, --output: The output file (no default)"
	printf '\t%s\n' "--open-pdf, --no-open-pdf: Open the PDF file after creating it (on by default)"
	printf '\t%s\n' "-h, --help: Prints help"
	printf '\t%s\n' "-v, --version: Prints version"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-o|--output)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_output="$2"
				shift
				;;
			--output=*)
				_arg_output="${_key##--output=}"
				;;
			-o*)
				_arg_output="${_key##-o}"
				;;
			--no-open-pdf|--open-pdf)
				_arg_open_pdf="on"
				test "${1:0:5}" = "--no-" && _arg_open_pdf="off"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			-v|--version)
				echo $(basename $0) 420.69
				exit 0
				;;
			-v*)
				echo $(basename $0) 420.69
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	local _required_args_string="'name-or-file'"
	test "${_positionals_count}" -ge 1 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require between 1 and 2 (namely: $_required_args_string), but got only ${_positionals_count}." 1
	test "${_positionals_count}" -le 2 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect between 1 and 2 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_name_or_file _arg_section "

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

# vvv  PLACE YOUR CODE HERE  vvv

# figure out if we're dealing with a name or a file
FILE=""
if [[ -f "$_arg_name_or_file" ]]; then
  NAME=$(basename "$_arg_name_or_file")
  FILE="$_arg_name_or_file"
else
  # use 'man -w' to get file, optionally passing section if provided
  NAME="$_arg_name_or_file"
  MAN_ARGUMENTS="$NAME"
  SECTION="$_arg_section"
  if [[ -n "$SECTION" ]]; then
    MAN_ARGUMENTS="$SECTION $MAN_ARGUMENTS"
  fi
  FILE=$(man -w $MAN_ARGUMENTS)
fi

# if we don't have a file, exit
if [[ -z "$FILE" ]]; then
  exit 1
fi

# get output file. If no output is provided default to /tmp/NAME.pdf
OUTPUT="/tmp/$NAME.pdf"
if [[ -n "$_arg_output" ]]; then
  OUTPUT="$_arg_output"
fi

echo "Generating PDF for '$NAME'"

groff -Tpdf -mandoc -c $FILE > $OUTPUT

# open the file if we are told to
if [[ "$_arg_open_pdf" == "on" ]]; then
  open $OUTPUT
fi

# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash

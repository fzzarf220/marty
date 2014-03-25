
# output error 
# @param $1 string the error to strerr
# @output string the error message
# @return code 1 for error 
function common_error
{
	echo "(!) ERROR: $1" >&2
	echo 
	return 0
}

# expand the arguments give
# @output string the options expanded
# @return code 0 on success
function common_args_expand
{
 	echo "function common_args_expand()" >&2
	echo "args: $@" >&2
	echo "\$1: $1" >&2 
	echo "\$2: $2" >&2 
	echo "\$3: $3" >&2 
	echo "\$4: $4" >&2 
	echo "\$5: $5" >&2
	echo  >&2  

	for i in $(seq $#); do
		# if short option with multiple options, like -abc
		if [ "${1:0:1}" == "-" ] && 
			[ "${1:1:1}" != "-" ] && 
			[ "${#1}" -gt 2 ]; then
				for i in $(seq 1 ${#1}); do
					[ -z "${1:$i:1}" ] && continue
					echo -n "-${1:$i:1} "
				done
		else
			# check if equals in option
			grep '=' <(echo "$1") &>/dev/null

			if [ $? -eq 0 ] && [ "${1:0:2}" == "--" ]; then
				echo -n "$(sed 's/\(--[^=]*\)=\(.*\)/\1 \2/g' <(echo "$1"))"
			else 
				echo -n "$1 "
			fi
		fi

		shift
	done

	return 0
}

# trim given arguments, can take multiple arguments
# @param string $1 the argument to trim
# @return code 0 on success else >=1 on error
# @output string the trimmed output 
function trim
{
	[ "$#" -le 0 ] && return 0

	while true; do
		[ -z "$1" ] && break
		sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g' <(echo "$1")
		shift
	done
}
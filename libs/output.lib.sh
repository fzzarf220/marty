
# @access private
# output with a given prefix either via passed args or pipe (file descriptor)
# the function can be used in the following forms:
#    output_prefix PREFIX LINE
#    output_prefix PREFIX ONE TWO THREE...
# @param string $1 the prefix
# @param string $2 (optional) default to true to trim leading spaces, else false
# @param string $3 the output to add prefix, can be other params as well
# @output string the prefixed syntax
# @return code 0 on success 
function _output_prefix
{
	local prefix="$1" 
	local trim="true"

	# check if trim is disabled
	[ "$2" == "false" ] && 
		trim="false"

	shift 2

	# if output indent called without argument
	[ "$#" -le 0 ] && 
		printf "%b%s\n" "$prefix" "" && 
		return 0

	# traverse all args
	for i in $(seq $#); do
		while IFS='' read -r line; do
			[ "$trim" == "true" ] && 
				line="$(trim "$line")"

			printf "%b%s\n" "$prefix" "$line"
		done< <(echo "$1")

		shift
	done

	return 0
}

# indent the string provided via arguments or pipe (file descriptor)
# @output string the indented output
# @return code 0 on success
function output_indent
{
	local prefix="\t"

	# check if pipe
	if [ -p /dev/fd/0 ]; then
		while IFS='' read -r line; do
			_output_prefix "$prefix" "false" "$line"
		done
	else
		_output_prefix "$prefix" "false" "$@"
	fi
	
	return 0
}

# prefix output with timestamp
# @param string $1 the prefix
# @param string $2 the output to add prefix, can be other params as well
# @output string the prefixed syntax
# @return code 0 on success 
function output_prefix_timestamp
{
	# set format
	local date_format="%X"

	# set prefix
	local prefix=""
	[ -n "$1" ] && prefix=" $1"

	# check if pipe
	if [ -p /dev/fd/0 ]; then
		while IFS=$'' read -r line; do
			_output_prefix "[$(date "+${date_format}")]$prefix" "true" "$line"
		done
	else
		[ -n "$1" ] && shift
		_output_prefix "[$(date "+${date_format}")]$prefix" "true" "$@" 
	fi

	return 0
}

# prefix output with timestamp
# @param string $1 the prefix
# @param string $2 the date format which needs to be compatible 
#     with GNU date, empty for default 
# @param string $3 the output to add prefix, can be other params as well
# @output string the prefixed syntax
# @return code 0 on success 
function output_prefix_timestamp_custom
{
	# set prefix
	local prefix=""
	[ -n "$1" ] && prefix=" $1"

	# set format
	local date_format="%X"
	[ -n "$2" ] && date_format="$2"

	shift 2

	# check if pipe
	if [ -p /dev/fd/0 ]; then
		while IFS=$'' read -r line; do
			_output_prefix "[$(date "+${date_format}")]$prefix" "true" "$line"
		done
	else
		_output_prefix "[$(date "+${date_format}")]$prefix" "true" "$@" 
	fi

	return 0
}
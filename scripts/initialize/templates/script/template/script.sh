
# script version
MARTY_VERSION_%%NAME%%="1.0"

# output help docs, if provided then also the error message and exit with error code
# @param string $1 (optional) error message
# @return void 
# @return code 0 on success else >= 1 on error
function usage_%%NAME%%
{
	local code=0
	MARTY_SCRIPT_NAME="$(basename $0)"
	
	if [ -n "$1" ]; then
		echo "(!) ERROR: $1" >&2
		echo ""
		code=1
	fi 
	
	echo -e "$(cat <<-EOF
		Usage:\t$MARTY_SCRIPT_NAME %%NAME%% [OPTIONS]

		$(cat $MARTY_PATH_SCRIPT/description 2>/dev/null)

		General option(s):
		\t--help, -h                        output help documents
		\t--version, -v                     output script version
		
		Examples:
		\t$MARTY_SCRIPT_NAME %%NAME%% --help
		\t$MARTY_SCRIPT_NAME %%NAME%% -v

		\n
	EOF
	)"
}

# validate inputs
# @output string output messages during validation
# @return code 0 on success else >= 1 on error
function validate_%%NAME%%
{
	[ "$#" -eq 0 ] && 
		usage_%%NAME%% && 
		return 0 

	# expand args
	eval set -- "$(common_args_expand $@)"

	while true; do
		[ -z "$1" ] && 
			break

		local arg="$1"
		local value="$2"

		case "$arg" in
			--help|-h)
				usage_%%NAME%%
				return 0
				;;
			--version|-v)
				echo "$MARTY_VERSION_%%NAME%%"
				echo 
				return 0
				;;
			*)
				# chack invalid flags
				[ ${arg:0:1} == "-" ] &&
					usage_%%NAME%% "Invalid option '$1'" &&
					return 1
				;;
		esac

		shift
	done

	return 0
}

# the run function for the script
# @output string the output 
# @return code 0 for success else >= 1 on error
function run_%%NAME%%
{
	# validate the args
	validate_%%NAME%% "$@"

	return 0
}

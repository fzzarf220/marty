
# script version
MARTY_VERSION_initialize="1.0"

# output help docs, if provided then also the error message and exit with error code
# @param string $1 (optional) error message
# @return void 
# @return code 0 on success else >= 1 on error
function usage_initialize
{
	local code=0
	MARTY_SCRIPT_NAME="$(basename $0)"
	
	if [ -n "$1" ]; then
		echo "(!) ERROR: $1" >&2
		echo ""
		code=1
	fi 
	
	echo -e "$(cat <<-EOF
		Usage:\t$MARTY_SCRIPT_NAME template [OPTIONS]
		\t$MARTY_SCRIPT_NAME template NAME

		$(cat $MARTY_PATH_SCRIPT/description 2>/dev/null)

		Manditory argument(s):
		\tNAME                              the template file name

		General option(s):
		\t--help, -h                        output help documents
		\t--version, -v                     output script version
		
		List options(s):
		\t--list-templates,-l               list templates

		Examples:
		\t$MARTY_SCRIPT_NAME template --help
		\t$MARTY_SCRIPT_NAME template -v

		\n
	EOF
	)"
}

# copy content of local template directory to desired location
# @param string $1 the destination path
# @output string verbose output
# @return code 0 on success else >=1 on error
function copy_template_dir
{
	cp -vr "$MARTY_PATH_TEMPLATE/template" "$1"
	return $?
}

# validate inputs
# @output string output messages during validation
# @return code 0 on success else >= 1 on error
function validate_initialize
{
	[ "$#" -eq 0 ] && 
		usage_initialize && 
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
				usage_initialize
				return 0
				;;
			--version|-v)
				echo "$MARTY_VERSION_initialize"
				echo 
				return 0
				;;
			--list-templates|-l)
				cd "$MARTY_PATH_SCRIPT/templates"

				for name in $(find ./ -maxdepth 1 -type d \
					| sed 's#^\./##g' \
					| grep -v '^\s*$' \
					| sort -u); do
						printf "%-30s %s\n" "$name" "$(cat "$name/description" 2>/dev/null)"
				done

				echo
				return 0
				;;
			*)
				# chack invalid flags
				[ ${arg:0:1} == "-" ] &&
					usage_initialize "Invalid option '$1'" &&
					return 1

				MARTY_PATH_TEMPLATES="${MARTY_PATH_SCRIPT}/templates"
				MARTY_PATH_TEMPLATE="${MARTY_PATH_TEMPLATES}/$arg"

				#echo "MARTY_PATH_TEMPLATES: $MARTY_PATH_TEMPLATES"
				#echo "MARTY_PATH_TEMPLATE:  $MARTY_PATH_TEMPLATE"				

				# check if given template exists
				[ ! -f "${MARTY_PATH_TEMPLATE}/script.sh" ] &&
					common_error "invalid template script '$arg'" &&
					return 1

				(
					# load template
					. "${MARTY_PATH_TEMPLATE}/script.sh"
					echo 
					printf "${COLOR_BYELLOW}%s:${COLOR_RESET}\n" "Running template script"
					template "$@" | output_indent
					[ ${PIPESTATUS[0]} -ne 0 ] && 
						exit ${PIPESTATUS[0]}

					echo 
					printf "${COLOR_BYELLOW}%s:${COLOR_RESET}\n" "Summary report"
					summary "$@" | output_indent
					echo
				)

				return $?
				;;
		esac

		shift
	done

	return 0
}

function run_initialize
{
	# validate the args
	validate_initialize "$@"
}

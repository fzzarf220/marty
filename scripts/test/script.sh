
# script version
MARTY_VERSION_test="1.0"
_flag_summary="true"
_flag_quite_mode="true"
_flag_tests=()

# output help docs, if provided then also the error message and exit with error code
# @param string $1 (optional) error message
# @return void 
# @return code 0 on success else >= 1 on error
function usage_test
{
	code=0
	MARTY_SCRIPT_NAME="$(basename $0)"
	
	if [ -n "$1" ]; then
		echo "(!) ERROR: $1" >&2
		echo ""
		code=1
	fi 
	
	echo -e "$(cat <<-EOF
		Usage:\t$MARTY_SCRIPT_NAME test NAME [NAME [NAME [...]]] [OPTIONS]

		$(cat $MARTY_PATH_SCRIPT/description 2>/dev/null)

		Mandatory option(s):
		\tNAME                              the test case script name to run

		General option(s):
		\t--help, -h                        output help documents
		\t--version, -v                     output script version

		Test option(s):
		\t--all,-a                          run all tests
		\t--case="NUMBER[ NUMBER[ ...]],"   to test specific case number
		\t   -c "NUMBER[ NUMBER[ ...]]"
		\t--details, -d                     to show details of the case
		\t--list-cases,-l                   list the test t--list-cases
		
		Examples:
		\t$MARTY_SCRIPT_NAME test --help
		\t$MARTY_SCRIPT_NAME test -v

		\n
	EOF
	)"
}

# validate inputs
# @output string output messages during validation
# @return code 0 on success else >= 1 on error
function validate_test
{
	[ "$#" -eq 0 ] && 
		usage_test && 
		return 0 

	# expand args
	eval set -- "$(common_args_expand "$@")"

	while true; do
		[ -z "$1" ] && 
			break

		local arg="$1"
		local value="$2"

		case "$arg" in
			--all|-a)
				for test in $(cd "${MARTY_PATH_SCRIPT}/cases"; /bin/ls -1d *); do
					# check if the test case exists
					[ ! -f "${test}/test.sh" ] && 
						continue

					_flag_tests[${#_flag_tests[@]}]="$test"
				done

				echo "tests: ${_flag_tests[@]}"
				;;
			--case|-c)
				_flag_case_numbers="${_flag_case_numbers}$value "
				shift
				;;
			--details|-d)
				_flag_quite_mode="false"
				;;
			--help|-h)
				usage_test
				exit 0
				;;
			--version|-v)
				echo "$MARTY_VERSION_test"
				echo 
				exit 0
				;;
			--list-cases|-l)
				[ ! -d "${MARTY_PATH_SCRIPT}/cases" ] && 
					echo -e "no test cases found\n" &&
					exit 0

				cd "${MARTY_PATH_SCRIPT}/cases"

				for name in $(ls -1d *); do
					[ ! -f "${name}/test.sh" ] && continue

					printf "%-30s %s\n" "$name" "$(cat ${name}/description 2>/dev/null)"
				done

				echo
				;;
			*)
				# chack invalid flags
				[ ${arg:0:1} == "-" ] &&
					usage_test "Invalid option '$1'" &&
					return 1

				# check if the test case exists
				[ ! -f "${MARTY_PATH_SCRIPT}/cases/${arg}/test.sh" ] && 
					usage_test "Test script '$arg' not found" &&
					return 1

				_flag_tests[${#_flag_tests[@]}]="$arg"
				;;
		esac

		shift
	done

	return 0
}

# run the test case
# @param string $1 the path to test case script
# @param integer $2 space delimited list of case numbers
# @param string $3 (optional) true for quiet mode else verbose mode
# @output string the output
# @return code 0 on a successful run else >= 1 for the number of failed cases
function run_script
{
	local path_test="$1"
	source "${path_test}"
	
	local quite_mode="false"
	[ "$3" == "true" ] && 
		quite_mode="true"

	local cases="$2"
	[ -z "$cases" ] && 
		cases="$(seq ${#test_case[@]})"

	local overall=0

	# traverse the tests
	for j in ${cases}; do
		local status="${COLOR_GREEN}SUCCESS${COLOR_RESET}"
		local result=""
		local index="$((( $j-1 )))"

		if [ "$quite_mode" != "true" ]; then
			printf "${COLOR_BYELLOW}%s:${COLOR_RESET} %s\n" "case" "$j"
			printf "${COLOR_BYELLOW}%s:${COLOR_RESET} %s\n" "description" "${test_description[$index]}"
			printf "${COLOR_BYELLOW}%s:${COLOR_RESET}\n" "code"
			nl <(echo "${test_case[$index]}")
			echo
			printf "${COLOR_BYELLOW}%s:${COLOR_RESET}\n" "output"
		else
			printf "%5s %-80s " "$j" "${test_description[$index]}"
		fi

		# execute the test script 
		while IFS='' read -r line; do
			result="${result}${line}\n"

			[ "$quite_mode" != "true" ] &&
				echo "$line" | output_indent 
		done< <(
			bash<<-EOF 2>&1
				MARTY_PATH="$MARTY_PATH"
				MARTY_PATH_TMP="$MARTY_PATH_TMP"
				MARTY_PATH_CONFIGS="$MARTY_PATH_CONFIGS"
				MARTY_PATH_SCRIPTS="$MARTY_PATH_SCRIPTS"
				MARTY_PATH_SCRIPT="$MARTY_PATH_SCRIPT"
				MARTY_PATH_LIBS="$MARTY_PATH_LIBS"

				${test_case[$index]}
			EOF
		)

		#code="$?"

		if [ "$code" -ne 0 ]; then
			status="${COLOR_BRED}FAILURE${COLOR_RESET} - error at executing script" 
			((overall++))
		else
			# compare the result
			result="$(diff -y --strip-trailing-cr \
				<(echo -e "$result" | nl) \
				<(echo "${test_expected[$index]}" | nl) 2>&1)"

			[ $? -ne 0 ] && 
				status="${COLOR_BRED}FAILURE${COLOR_RESET}" && 
				((overall++))
		fi

		if [ "$quite_mode" != "true" ]; then
			echo
			printf "${COLOR_BYELLOW}%s:${COLOR_RESET}\n" "result (actual vs expected)"
			echo "$result"
			printf "${COLOR_BYELLOW}%s:${COLOR_RESET} " "status" 
		fi

		echo -e "$status"

		[ "$quite_mode" != "true" ] && 
			echo "-------------------------------------------------------------" &&
			echo
	done

	return $overall
}

# the run function for script
function run_test
{
	local code
	local status="${COLOR_GREEN}SUCCESS${COLOR_RESET}"
	# validate the args
	validate_test "$@"
	code="$?"

	[ "$code" -ne 0 ] && return "$code"

	# traverse the test cases
	for i in $(seq 0 ${#_flag_tests[@]}); do
		[ -z "${_flag_tests[$i]}" ] && continue

		local path_test="${MARTY_PATH_SCRIPT}/cases/${_flag_tests[$i]}/test.sh"

		[ ! -f "${path_test}" ] && 
			output_error "unknown case '${_flag_tests[$i]}'" &&
			continue

		printf "${COLOR_BYELLOW}%s:${COLOR_RESET} %s\n" "script" "${_flag_tests[$i]}"
		printf "${COLOR_BYELLOW}%s:${COLOR_RESET} %s\n" \
			"description" "$(cat ${MARTY_PATH_SCRIPT}/cases/${_flag_tests[$i]}/description 2>/dev/null || echo "n/a")"
		printf "${COLOR_BYELLOW}%s:${COLOR_RESET}\n" "cases"
		
		if [ "$_flag_quite_mode" == "true" ]; then 
			printf "%5s %-80s %s\n" "case" "description" "status"
			echo "-----------------------------------------------------------------------------------------------"
		fi | output_indent

		run_script "${path_test}" "$_flag_case_numbers" "$_flag_quite_mode" | output_indent
		code=${PIPESTATUS[0]}

		[ "$code" -ne 0 ] && 
			status="${COLOR_BRED}FAILURE${COLOR_RESET} ($code cases failed)"

		echo
		printf "${COLOR_BYELLOW}%s:${COLOR_RESET} %b\n" "status" "$status"
		echo
	done
}

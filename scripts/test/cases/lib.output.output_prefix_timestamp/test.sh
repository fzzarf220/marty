
# ouput test
_case_counter=0

##########################################
# includes 
##########################################
# place anything needed here

##########################################
# case 1
##########################################
test_description[${_case_counter}]="prefix timestamp via pipe"
test_case[${_case_counter}]="$(cat <<-'TEST'
	. ${MARTY_PATH_LIBS}/common.lib.sh
	. ${MARTY_PATH_LIBS}/output.lib.sh

	(
		echo "hello world"
		echo
		echo "hello world a second time"
	) | output_prefix_timestamp "[one] "
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
[$(date +%X)] [one] hello world
[$(date +%X)] [one] 
[$(date +%X)] [one] hello world a second time
"
# increment the case counter
((_case_counter++))

##########################################
# case 2
##########################################
test_description[${_case_counter}]="prefix timestamp via argument"
test_case[${_case_counter}]="$(cat <<-'TEST'
	. ${MARTY_PATH_LIBS}/common.lib.sh
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_prefix_timestamp "[some] [prefix] " "$(
		echo "hello world"
		echo
		echo "hello world a second time"
	)"
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
[$(date +%X)] [some] [prefix] hello world
[$(date +%X)] [some] [prefix] 
[$(date +%X)] [some] [prefix] hello world a second time
"
((_case_counter++))

##########################################
# case 3
##########################################
test_description[${_case_counter}]="prefix timestamp via argument 2"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/common.lib.sh
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_prefix_timestamp "[some] [prefix] " "hello world"
	output_prefix_timestamp "[some] [prefix] "
	output_prefix_timestamp "[some] [prefix] " "hello world a second time"
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
[$(date +%X)] [some] [prefix] hello world
[$(date +%X)] [some] [prefix] 
[$(date +%X)] [some] [prefix] hello world a second time
"
((_case_counter++))

##########################################
# case 4
##########################################
test_description[${_case_counter}]="prefix timestamp empty"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/common.lib.sh
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_prefix_timestamp "[some] [prefix] "
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
[$(date +%X)] [some] [prefix] 
"
((_case_counter++))

##########################################
# case 5
##########################################
test_description[${_case_counter}]="prefix timestamp two empty"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/common.lib.sh
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_prefix_timestamp "[some] [prefix] "
	output_prefix_timestamp "[some] [prefix] "
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
[$(date +%X)] [some] [prefix] 
[$(date +%X)] [some] [prefix] 
"
((_case_counter++))

##########################################
# case 6
##########################################
test_description[${_case_counter}]="prefix timestamp single string"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/common.lib.sh
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_prefix_timestamp "[some] [prefix] " "hello"
	output_prefix_timestamp "[some] [prefix] " "world"
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
[$(date +%X)] [some] [prefix] hello
[$(date +%X)] [some] [prefix] world
"
((_case_counter++))

##########################################
# case 7
##########################################
test_description[${_case_counter}]="prefix timestamp single string via pipe"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/common.lib.sh
	. ${MARTY_PATH_LIBS}/output.lib.sh

	echo "hello" | output_prefix_timestamp "[some] [prefix] "
	echo "world" | output_prefix_timestamp "[some] [prefix] "
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
[$(date +%X)] [some] [prefix] hello
[$(date +%X)] [some] [prefix] world
"
((_case_counter++))

##########################################
# case 8
##########################################
test_description[${_case_counter}]="prefix timestamp with leading spaces, via pipe"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/common.lib.sh
	. ${MARTY_PATH_LIBS}/output.lib.sh

	(
		echo "hello"
		echo "          world"
	) | output_prefix_timestamp "[some] [prefix] "
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
[$(date +%X)] [some] [prefix] hello
[$(date +%X)] [some] [prefix] world
"
((_case_counter++))

##########################################
# case 9
##########################################
test_description[${_case_counter}]="prefix timestamp with leading spaces, via args"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/common.lib.sh
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_prefix_timestamp "[some] [prefix] " "hello"
	output_prefix_timestamp "[some] [prefix] "
	output_prefix_timestamp "[some] [prefix] " "          world"
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
[$(date +%X)] [some] [prefix] hello
[$(date +%X)] [some] [prefix] 
[$(date +%X)] [some] [prefix] world
"
((_case_counter++))

##########################################
# case 10
##########################################
test_description[${_case_counter}]="prefix custom timestamp with leading spaces, via pipe"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/common.lib.sh
	. ${MARTY_PATH_LIBS}/output.lib.sh

	(
		echo "hello"
		echo "          world"
	) | output_prefix_timestamp_custom "[some] [prefix] " "%B %d, %Y %H:%M:%S"
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
[$(date +"%B %d, %Y %H:%M:%S")] [some] [prefix] hello
[$(date +"%B %d, %Y %H:%M:%S")] [some] [prefix] world
"
((_case_counter++))

##########################################
# case 11
##########################################
test_description[${_case_counter}]="prefix custom timestamp with leading spaces, via args"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/common.lib.sh
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_prefix_timestamp_custom "[some] [prefix] " "%B %d, %Y %H:%M:%S" "hello"
	output_prefix_timestamp_custom "[some] [prefix] " "%B %d, %Y %H:%M:%S"
	output_prefix_timestamp_custom "[some] [prefix] " "%B %d, %Y %H:%M:%S" "          world"
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
[$(date +"%B %d, %Y %H:%M:%S")] [some] [prefix] hello
[$(date +"%B %d, %Y %H:%M:%S")] [some] [prefix] 
[$(date +"%B %d, %Y %H:%M:%S")] [some] [prefix] world
"
((_case_counter++))



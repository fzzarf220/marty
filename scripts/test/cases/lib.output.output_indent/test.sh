
# ouput test
_case_counter=0

##########################################
# includes 
##########################################
# place anything needed here

##########################################
# case 1
##########################################
test_description[${_case_counter}]="indent output, via pipe"
test_case[${_case_counter}]="$(cat <<-'TEST'
	. ${MARTY_PATH_LIBS}/output.lib.sh

	(
		echo "hello world"
		echo
		echo "hello world a second time"
	) | output_indent
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
	hello world
	
	hello world a second time
"
# increment the case counter
((_case_counter++))

##########################################
# case 2
##########################################
test_description[${_case_counter}]="indent output, via argument"
test_case[${_case_counter}]="$(cat <<-'TEST'
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_indent "$(
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
	hello world
	
	hello world a second time
"
((_case_counter++))

##########################################
# case 3
##########################################
test_description[${_case_counter}]="indent output, via argument 2"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_indent "hello world"
	output_indent
	output_indent "hello world a second time"
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
	hello world
	
	hello world a second time
"
((_case_counter++))


##########################################
# case 4
##########################################
test_description[${_case_counter}]="indent output, empty"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_indent
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
	
"
((_case_counter++))

##########################################
# case 5
##########################################
test_description[${_case_counter}]="indent output, two empty"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_indent
	output_indent
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
	
	
"
((_case_counter++))

##########################################
# case 6
##########################################
test_description[${_case_counter}]="indent output, single string"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_indent "hello"
	output_indent "world"
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
	hello
	world
"
((_case_counter++))

##########################################
# case 7
##########################################
test_description[${_case_counter}]="indent output, single string via pipe"
test_case[${_case_counter}]="$(cat <<'TEST'
	. ${MARTY_PATH_LIBS}/output.lib.sh

	echo "hello" | output_indent
	echo "world" | output_indent
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
	hello
	world
"
((_case_counter++))

##########################################
# case 8
##########################################
test_description[${_case_counter}]="indent output with leading space, via pipe"
test_case[${_case_counter}]="$(cat <<-'TEST'
	. ${MARTY_PATH_LIBS}/output.lib.sh

	(
		echo "          hello world"
		echo
		echo "hello world a second time"
	) | output_indent
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
	          hello world
	
	hello world a second time
"
# increment the case counter
((_case_counter++))

##########################################
# case 9
##########################################
test_description[${_case_counter}]="indent output with leading space, via argument"
test_case[${_case_counter}]="$(cat <<-'TEST'
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_indent "          hello world"
	output_indent
	output_indent "hello world a second time"
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
	          hello world
	
	hello world a second time
"
((_case_counter++))

##########################################
# case 10
##########################################
test_description[${_case_counter}]="indent output multiple args to single call"
test_case[${_case_counter}]="$(cat <<-'TEST'
	. ${MARTY_PATH_LIBS}/output.lib.sh

	output_indent "          hello world" "" "hello world a second time"
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="\
	          hello world
	
	hello world a second time
"
((_case_counter++))

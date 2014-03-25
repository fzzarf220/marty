
# ouput test
_case_counter=0

##########################################
# includes 
##########################################
# place anything needed here

##########################################
# case 1
##########################################
test_description[${_case_counter}]="test case description"
test_case[${_case_counter}]="$(cat <<-TEST
	# place test script here
TEST
)"
# if the expected is a regex or string
# @value boolean true for regex else false
test_expected_is_regex[${_case_counter}]="false"
test_expected[${_case_counter}]="$(cat <<-EXP
	# place expected output
EXP
)"
# increment the case counter
((_case_counter++))
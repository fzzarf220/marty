_name=""
_path_script=""


# output summary after the template has run successfully
function summary
{
	echo "name: $_name"
	echo "path script: $_path_script"
	<<-comment
	echo "The following test script was created:"
	output_indent "$_name"
	echo
	echo "The files have been initialized for script:"
	(cd $_path_script; find -type f) | output_indent
	comment
}

# the template logic here
function template
{
	# add the template logic
	# (!) NOTE - the below are some variable(s) available at run-time:
	#   MARTY_PATH_TEMPLATES  the absulute path to where all the templates are
	#	MARTY_PATH_TEMPLATE   the absolute path to the executing template
	# 	MARTY_PATH            absolute root path to marty
	#   MARTY_PATH_CONFIGS    absolute path to the configs directory
	#   MARTY_PATH_LIBS -     absolute path to the libs directory
	#   MARTY_PATH_SCRIPTS    absolute path to the scripts dir
	
	###########################################
	# template example:
	# the below is an example of a template script, feel free to expand on the script
	# get name
	read -p "name (no spaces): " _name

	# check if name given
	[ -z "$_name" ] && 
		common_error "no name given" && 
		return 1

	# check if any spaces
	egrep '[ ]+' <(echo "$_name") &>/dev/null

	[ $? -eq 0 ] && 
		common_error "spaces in name" && 
		return 1

	_path_script="${MARTY_PATH_SCRIPTS}/test/cases/${_name}"
	[ -d "$_path_script" ] && [ -f "${_path_script}/test.sh" ] &&
		common_error "the test script '$_name' already exists" &&
		return 1

	# description input
	description=""
	read -p "description: " description

	copy_template_dir "$_path_script"
	echo "$description" > "${_path_script}/description"

	return 0
}

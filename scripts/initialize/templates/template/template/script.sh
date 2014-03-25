
# output summary after the template has run successfully
function summary
{
	echo ""
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
	name=""

	# get name
	read -p "name (no spaces): " name

	# check if name given
	[ -z "$name" ] && 
		common_error "no name given" && 
		return 1

	# check if any spaces
	egrep '[ ]+' <(echo "$name") &>/dev/null

	[ $? -eq 0 ] && 
		common_error "spaces in name" && 
		return 1  

	return 0
}

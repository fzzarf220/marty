path_script=""

function summary
{
	echo ""
}

function template
{
	name=""
	description=""

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

	# check if script exists
	[ -d "${MARTY_PATH_SCRIPTS}/$name" ] &&
		common_error "the script '$name' already exists" && 
		return 1 

	# get description
	read -p "description: " description

	copy_template_dir "${MARTY_PATH_SCRIPTS}/$name"
	sed -i \
		-e "s/%%NAME%%/$name/g" \
		-e "s/%%DESCRIPTION%%/$description/g" \
		"${MARTY_PATH_SCRIPTS}/$name/script.sh"

	echo "creating description file at '${MARTY_PATH_SCRIPTS}/$name/description'"
	echo "$description" > "${MARTY_PATH_SCRIPTS}/$name/description"

	return 0
}

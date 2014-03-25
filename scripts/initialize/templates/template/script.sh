
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
	[ -d "${MARTY_PATH_TEMPLATES}/$name" ] &&
		common_error "the template '$name' already exists" && 
		return 1 

	# get description
	read -p "description: " description

	# cp -rv "${MARTY_PATH_TEMPLATE}/template" "${MARTY_PATH_TEMPLATES}/$name"
	copy_template_dir "${MARTY_PATH_TEMPLATES}/$name"
	
	sed -i \
		-e "s/%%NAME%%/$name/g" \
		-e "s/%%DESCRIPTION%%/$description/g" \
		"${MARTY_PATH_TEMPLATES}/$name/script.sh"

	echo "creating description file at '${MARTY_PATH_TEMPLATES}/$name/description'"
	echo "$description" > "${MARTY_PATH_TEMPLATES}/$name/description"

	return 0
}

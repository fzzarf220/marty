
# list the available profile and respective description
# @param string (optional) a valid profile name, if provided will only list the given profile
# @param boolean (optional) true to only display profile name, defaults to 
# @output string the list
# @return code on success 0 else >=1 on error
function profile_list
{
	(
		code=1
		cd "${MARTY_PATH_CONFIGS}"

		for profile in $(find -maxdepth 1 -type d); do
			description=""

			# if searching for specific profile name
			[ -n "$1" ] && [ "$1" != "$profile" ] && 
				continue
			# if not profile config
			[ ! -f "${profile}/profile.config" ] && 
				continue
			# if not interested in description
			[ "$2" != "true" ] && 
				. "${profile}/profile.config"

			code=0
			printf "%-30s %s\n" "$profile" "$description"
		done 

		exit $code
	)

	return $?
}

# output the currently selected profile, if none set then select the first
# @output string the profile currently seleccted
# @return code on success 0 else >=1 on error
function profile_current
{
	# output the first profile if none set
	profile_list "${MARTY_PROFILE}" "false" | head -1
	[ ${PIPESTATUS[0]} -ne 0 ] && 
		return 1
	return 0
}
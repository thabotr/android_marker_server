welcome()
{
	local result="Welcome, $1!"
	#return "Welcome to the world of bash." < return in bash only provides integers 0-255
	echo $result #< we'll capture this from the caller
}

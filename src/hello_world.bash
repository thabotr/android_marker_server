welcome()
{
	local result="Welcome, $1!"
	#return "Welcome to the world of bash." < return in bash only provides integers 0-255
	echo $result #< we'll capture this from the caller

	res="$(emulator -version 2>&1 | head -n 1 | cat )"
	echo 7
	echo $res
}

bool_func()
{
	if [ $# -eq 1 ]; then
		true	
	else
		false
	fi
}

var="hello
peter
pan"

#IFS='\n' read -ra my_array <<< "$var"
#my_array=($( echo $var | tr '\n' '\n'))
#for w in "${my_array[@]}"
#do
#	echo "hello $w"
#done

#my_arr=($(echo))
#echo "Array length is ${#my_arr[@]}"

#echo ${my_array[*]} | grep pom
#my_arr="hello"

#for w in ${my_arr[@]}
#do
#	echo "Hello $w"
#done

echo_arr()
{
	my_arr="$@"
	echo "No of params $# "
	for i in ${my_arr[@]}
	do
		echo "Hello $i"
	done
}

arr=( avd1 avd2 )

echo_arr ${arr[@]}

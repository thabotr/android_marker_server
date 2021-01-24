#installs the platform tools package which contains the adb

#given the root directory for avd logs, and list of avd ids, waits for all of them to finish booting
wait_for_avds()
{
	if [ ! $# -gt 0 ];
	then
		echo "Please provide the root directory for log files, an id of an avd, or a list of ids for avds."
		exit 1
	fi

	if [ ! -d $1 ];
	then
		echo "'$1' is an invalid directory for avd log files."
	fi

	if [[ $2 == "all_avds" ]];
	then
		#get a list of online avds
		get_list_of_online_avds
		#wait out each one for boot
		for avd in ${onlineAvdList[@]}
		do
			while ! [ $( avd_boot_complete $avd $1 ) ]
			do
				sleep 10
			done
		done
	else
		args="$@"
		#iterate through all ids provided as arguments
		for i in $( seq $# );
		do
			while ! [ $( avd_boot_complete  ${args[$i]} $1 ) ]
			do
				sleep 10
			done
		done
	fi
}

#given the avd root firectory and a list of avds, boots and waits for them
start_avds()
{
	if [ $# -lt 2 ];
	then
		echo "Usage $0 <avd_log_directory> <list of avd ids>."
		return 1
	fi

	if [ ! -d $1 ];
	then
		echo "'$1' is not a valid avd logs directory."
		return 1
	fi

	for avd_id in ${@:2};
	do
		start_avd $avd_id $1
	done
}

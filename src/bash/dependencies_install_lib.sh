#this script will define functions to install android dependencies

#returns true if avd of given name exists
#else returns true if avd of any name exists
avd_exists()
{
	result="$( avdmanager list avds)"

	if [ $# -ne 1 ];
	then
		echo "No avd name provided. Checking if any avd exists."
		if [[ "$result" == *"Name:"* ]]; then
			return 0
		fi
	elif [[ $result == *"$1"* ]];then
		return 0
	fi

	return 1
}

#returns true if all of the given avds exist
avds_exist()
{
	if [ ! $# -gt 0 ];
	then
		echo "Please provide a list of avds to test for existence."
		return 1
	fi

	avds="$@"
	get_list_of_avds
	for avd in ${avds[@]}
	do
		echo ${avdList[@]} | grep $avd
	done
}

#returns true if the given avd is deleted
delete_avd()
{
	if [ $# -ne 1 ];then
		echo "Please provide avd name for deletion."
		exit 1
	fi

	avdmanager delete avd -n $1
	echo "Deleted avd '$1'"
}

#starts an emulator id and root folder for loging avd output
start_avd()
{
	if [ $# -ne 2 ];
	then
		echo "Failed to start emulator. Please provide avd id and folder for logging avd output."
		exit 1
	fi

	if [[ ! $1 == ?()+([0-9]) ]]; then
		echo "Failed to start emulator. Please provide a valid avd id."
		exit 1
	fi

	if ! [ -d $2 ]; then
		echo "Failed to start emulator. '$2' is an invalid path for avd logs."
		exit 1
	fi
	
	emulator_port=$(($1+5554)) #abd names devices as in the fashion 'emulator-<port#>'
	emulator_name="emulator-$emulator_port"

	log_file="$2/$emulator_name.log"
	touch $log_file 

	#avds are named by id
	emulator @$1 -port $emulator_port -gpu swiftshader_indirect -memory 512 -no-window -no-boot-anim -no-audio -no-snapshot -camera-front none -camera-back none -selinux permissive -no-accel -no-qt -wipe-data -stdouterr-file $log_file 2>&1 > $log_file & 
	
	if [ ! $? ]; then
		echo "Failed to start emulator."
		exit 1
	fi
}

#sets and exports a list of avds
get_list_of_avds()
{
	avdList=($( emulator -list-avds | tr '\n' '\n'))
	export avdList
}

#Given a list of avds, deletes them else deletes all on 'all_avds' given
delete_avds()
{
	if [ ! $# -gt 0 ];
	then
		echo "Provide avd id for deletion."
		exit 1
	elif [[ $1 == "all_avds" ]];
	then
		#get list of avds
		get_list_of_avds
		#then delete all avds
		for avd in ${avdList[@]}
		do
			delete_avd $avd
		done
	elif [ $# -gt 1 ];
	then
		emulators="$@"
		for avd in ${emulators[@]}
		do
			if avd_exists $avd ;
			then
				delete_avd $avd
			fi
		done
	fi
}

#waits for emulator given serial name else waits for any emulator
loud_wait_for_emulator()
{
	if [ $# -eq 1 ]; then
		echo "Waiting for device '$1'."
		adb -s $1 wait-for-device
	else
		adb wait-for-device
	fi
	
	echo $( adb devices )
}

#given the avd id, tools root directory and avd home, creates an avd that can be run from the cloud
create_default_avd()
{
	#check that avd name and avd root directory are given
	if [ $# -ne 3 ];
	then
		echo "Please provide an even integer id for avd in range [ 0, 256],directory of packages and avd home."
		exit 1
	fi

	#validate avd name to be an even numeric value in correct range
	if [[ ! $1 == ?()+([0-9]) ]] || [ $(( $1 % 2)) == 1 ] || [ $1 -lt 0 ] || [ $1 -gt 256 ];
	then
		echo "Please ensure avd id is an even integer in range [ 0, 256]."
		exit 1
	fi

	sys_im_dir="$2/system-images/android-27/default/x86_64"
	package="system-images;android-27;default;x86_64"

	if [ ! -d $sys_im_dir ];
	then
		echo "$sys_im_dir not found. Installing package '$package'."
		#install the package
		sdkmanager --install $package
	fi

	avd_name=$1
	avd_dir="$3/$avd_name.avd"

	if ! $( mkdir -p $avd_dir && chmod a+rw $avd_dir ); then
		echo "Error encountered while making directory '$avd_dir'"
		exit 1
	fi

	#create avd
	echo no | avdmanager create avd -f -n $avd_name -c "512M" -k $package
}

#sets and exports a list of online avds
get_list_of_online_avds()
{
	#list devices with adb
	#pick lines with the word 'emulator'
	#pick emulator with 'device' as opposed to offline
	#drop the word 'device' from each line
	#trim so we lest with 'emulator-<port>'
	onlineAvdList=($( adb devices | grep emulator | grep device | sed 's/device//g' | tr -d ' '))
	export onlineAvdList
}

#given the avd id or avd name and log root dir, checks if the given emulator has done booting
avd_boot_complete()
{
	if [ $# -ne 2 ];
	then
		echo "Please provide avd id and root directory for avd logs."
		exit 1
	fi

	if [[ $1 == *"emulator"* ]];
	then
		emu_name=$1
	else
		emu_name="emulator-$(( $1 + 5554 ))"
	fi

	log_file="$2/$emu_name.log"
	result="$( cat $log_file )"
	if [[ "$result" == *"boot complete"* ]];
	then
		return 0
	else
		return 1
	fi
}

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

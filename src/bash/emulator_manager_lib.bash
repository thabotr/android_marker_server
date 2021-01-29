#given avd id, android_home and android_avd_home
#creates the default avd
create_default_avd()
{
	id=$1
	create_avd $id "28" "default" "x86_64"
	return $?
}
export -f create_default_avd

#given avd id, api, tag and ABI creates an avd
#expects set vars $ANDROID_SDK_HOME, $ANDROID_AVD_HOME
create_avd()
{
	if [ -z $1 ] || ! ( echo $1 | grep -q -E '^[0-9]+$' ) || (( $1 > 120 )) || (( $1 % 2 ));
	then
		echo "<create_avd> Please provide an even number from 0 - 120 as an avd id."
		return 1
	fi

	if [ -z $2 ];
	then
		echo "<create_avd> Please provide the avd API as argument 2."
		return 1
	fi

	if [ -z $3 ];
	then
		echo "<create_avd> Please provide the avd TAG as argument 3."
		return 1
	fi

	if [ -z $4 ];
	then
		echo "<create_avd> Please provide the avd ABI as argument 4."
		return 1
	fi

	if [ -z $ANDROID_SDK_ROOT ];
	then
		echo "<create_avd> Please define ANDROID_SDK_ROOT variable."
		return 1
	fi

	if [ -z $ANDROID_AVD_HOME ];
	then
		echo "<create_avd> Please define ANDROID_AVD_HOME variable."
		return 1
	fi
	
	ID=$1
	API=$2
	TAG=$3
	ABI=$4

	if ! [ -d "$ANDROID_SDK_ROOT/system-images/android-$API/$TAG/$ABI" ];
	then
		echo "<create_avd> Directory '$ANDROID_SDK_ROOT/system-images/android-$API/$TAG/$ABI' not found."
		return 1
	fi
	sd_card_size="512M"
	image_package="system-images;android-$API;$TAG;$ABI"
	echo no | avdmanager create avd -f -n "avd$ID" -c $sd_card_size -k $image_package
	return $?
}
export -f create_avd

install_emulator_image()
{
	if [ -z $1 ];
	then
		echo "Please provide emulator API as first argument to function."
		return 1
	elif [ -z $2 ];
	then
		echo "Please provide emulator TAG as second argument to function."
		return 1
	elif [ -z $3 ];
	then
		echo "Please provide emulator ABI as third argument to function."
		return 1
	fi

	#arg1 is android API, arg2 is TAG, and arg3 is ABI
	#install image package
	API=$1
	TAG=$2
	ABI=$3
	sdkmanager --install "system-images;android-$API;$TAG;$ABI"
	sdkmanager --install "platforms;android-$API" #solves SDK installation not found problem
}
export -f install_emulator_image

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
export -f avd_exists

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
export -f avds_exist

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
export -f delete_avd

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
export -f start_avd

#sets and exports a list of avds
get_list_of_avds()
{
	avdList=($( emulator -list-avds | tr '\n' '\n'))
	export avdList
}
export -f get_list_of_avds

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
export -f delete_avds

#sets and exports a list of online avds
get_list_of_online_avds()
{
	#list devices with adb
	#pick lines with the word 'emulator'
	#pick emulator with 'device' as opposed to offline
	#drop the word 'device' from each line
	#trim so we left with 'emulator-<port>'
	onlineAvdList=($( adb devices | grep emulator | grep device | sed 's/device//g' | tr -d ' '))
	export onlineAvdList
}
export -f get_list_of_online_avds

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
export -f avd_boot_complete

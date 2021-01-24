install_emulator_image()
{
	#arg1 is android API, arg2 is TAG, and arg3 is ABI
	#install image package
	API=$1
	TAG=$2
	ABI=$3
	sdkmanager --install "system-images;android-$API;$TAG;$ABI"
	sdkmanager --install "platforms;android-$API" #solves SDK installation not found problem
}

#install 'emulator' package in the root of cmdline-tools
install_emulator()
{
	#check that sdk root directory is provided
	if [ $# -ne 1 ];
	then
		echo "Please provide directory into which the sdk is installed."
		exit 1
	elif [ ! -d $1 ];
	then
		echo "$1 does not exist."
		exit 1
	fi

	echo yes | sdkmanager --install emulator > /dev/null
	#install older packages for emulator
	echo yes | sdkmanager --install "build-tools;25.0.2" > /dev/null
	#install build tools version 28 for running x86_64 from canary
	echo yes | sdkmanager --install "build-tools;28.0.3" > /dev/null
	#install the relevant platform tools
	echo yes | sdkmanager --install "platforms;android-27" > /dev/null
	#install canary emulator
	echo yes | sdkmanager --channel=4 "emulator" > /dev/null
	#install avd package
	echo yes | sdkmanager "system-images;android-27;default;x86_64" > /dev/null

	echo yes | sdkmanager --install "tools"
	echo yes | sdkmanager --install "platforms;android-25" > /dev/null


	export PATH="$PATH:$1/emulator" # export the emulator folder into which the emulator binary resides
}

#installs the platform tools package which contains the adb
install_platform_tools()
{
	if [ $# -ne 1 ] || [ ! -d $1 ];
	then
		echo "Please provide the sdk root directory in which the platform tools will be installed."
		exit 1
	fi

	echo yes | sdkmanager --install platform-tools

	#change max port for adb we change this to accommodate 128 emulators
	export ADB_LOCAL_TRANSPORT_MAX_PORT=5812

	export PATH=$PATH:"$1/platform-tools"
}

install_emulator()
{
	#check that sdk root directory is provided
	if [ $# -ne 1 ];
	then
		echo "Please provide directory into which the sdk is installed."
		exit 1
	elif [ ! -d $1 ];
	then
		echo "$1 does not exist."
		exit 1
	fi

	echo yes | sdkmanager --install emulator > /dev/null
	#install older packages for emulator
	echo yes | sdkmanager --install "build-tools;25.0.2" > /dev/null
	#install build tools version 28 for running x86_64 from canary
	echo yes | sdkmanager --install "build-tools;28.0.3" > /dev/null
	#install the relevant platform tools
	echo yes | sdkmanager --install "platforms;android-27" > /dev/null
	#install canary emulator
	echo yes | sdkmanager --channel=4 "emulator" > /dev/null
	#install avd package
	echo yes | sdkmanager "system-images;android-27;default;x86_64" > /dev/null

	echo yes | sdkmanager --install "tools"
	echo yes | sdkmanager --install "platforms;android-25" > /dev/null


	export PATH="$PATH:$1/emulator" # export the emulator folder into which the emulator binary resides
}

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

#this script will define functions to install android dependencies

#install gradle into the given directory
install_gradle()
{
	#check that extraction directory is provided
	if [ $# -ne 1 ];
	then
		echo "Please provide directory in which to install gradle."
		exit 1
	elif [ ! -d $1 ];
	then
		echo "$1 does not exist."
		exit 1
	fi
	
	#download the gradle zip
	wget https://downloads.gradle-dn.com/distributions/gradle-6.6-bin.zip
	#unzip gradle into provided directory
	unzip -q -d $1 gradle*.zip
	#remove downloaded zip
	rm gradle*.zip
	
	#export gradle bin to path
	export PATH=$PATH:"$( echo $1/**/bin)"

}

#install java version 8
#will do a minimal install of java jvm and no GUI support
install_java()
{
	sudo apt install openjdk-8-jre-headless
}

#install sdk
install_sdk()
{
	#check that extraction directory is provided
	if [ $# -ne 1 ];
	then
		echo "Please provide directory in which to install the sdk."
		exit 1
	elif [ ! -d $1 ];
	then
		echo "$1 does not exist."
		exit 1
	fi

	#download android cli tools
	wget https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip

	#make cmdline-tools dir
	cmd_tools_dir="$1/cmdline-tools"
	mkdir $cmd_tools_dir

	#unzip and put in correct directories
	unzip -q -d $cmd_tools_dir commandline*.zip

	#clean up
	rm commandline*.zip

	#TODO export to path some important directories
	#export bin and tools directory to path
	export PATH=$PATH:"$( echo $cmd_tools_dir/**/bin)":"$( echo $cmd_tools_dir/tools)"
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
	export PATH=$PATH:"$1/platform-tools"
}

#given a system images in string, install that using sdk manager
#install_image()
#{
#	image = "system"
#	if [ $# -ne 1 ];
#	then
#		echo "System image not provided. Instaling \'$image\' by default."
#	else
#		$image = $1
#	fi
#	
#	#install the specified package
#	sdkmanager install $image
#}

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

##given the avd name, avd root directory and tools root directory, creates an avd that can be run from the cloud
#create_default_avd()
#{
#	#check that avd name and avd root directory are given
#	if [ $# -ne 3 ];
#	then
#		echo "Please provide name of avd and directory of packages."
#		return 20
#	fi
#
#	sys_im_dir="$2/system-images/android-25/google_apis/arm64-v8a"
#	package="system-images;android-25;google_apis;arm64-v8a"
#
#	if [ ! -d $sys_im_dir ];
#	then
#		echo "$sys_im_dir not found. Installing package '$package'."
#		#install the package
#		sdkmanager --install $package
#	fi
#
#	avd_name=$1
#	avd_dir="$3/$avd_name.avd"
#
#	if ! $( mkdir -p $avd_dir ); then
#		return 1
#	fi
#
#	#create avd
#	#sdcard size 512M
#	#tag google_apis
#	#abi arm64-v8a
#	#device id 19
#	avdmanager create avd -n $avd_name -c "512M" -k $package -g "google_apis" -b "arm64-v8a" -d 19 -f -p $avd_dir
#}

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
		echo "Please provide an even integer id for avd in range [ 0, 30],directory of packages and avd home."
		exit 1
	fi

	#validate avd name to be an even numeric value in correct range
	if [[ ! $1 == ?()+([0-9]) ]] || [ $(( $1 % 2)) == 1 ] || [ $1 -lt 0 ] || [ $1 -gt 30 ];
	then
		echo "Please ensure avd id is an even integer in range [ 0, 30]."
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
	#drop the word 'device' from each line
	#trim so we lest with 'emulator-<port>'
	onlineAvdList=($( adb devices | grep emulator | sed 's/device//g' | tr -d ' '))
	export onlineAvdList
}
 

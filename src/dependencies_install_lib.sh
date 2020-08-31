#this script will define functions to install android dependencies

#install gradle into the given directory
install_gradle()
{
	#check that extraction directory is provided
	if [ $# -ne 1 ];
	then
		echo "Please provide directory in which to install gradle."
		return 20
	elif [ ! -d $1 ];
	then
		echo "$1 does not exist."
		return 20
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
		return 20
	elif [ ! -d $1 ];
	then
		echo "$1 does not exist."
		return 20
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
		return 1
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
		return 20
	elif [ ! -d $1 ];
	then
		echo "$1 does not exist."
		return 20
	fi
	echo yes | sdkmanager --install emulator 2>&1 > /dev/null
	#install older packages for emulator
	echo yes | sdkmanager --install "build-tools;25.0.2"

	#echo yes | sdkmanager --install "tools"
	
	echo yes | sdkmanager --install "platforms;android-25"

	export PATH="$PATH:$1/emulator" # export the emulator folder into which the emulator binary resides
}

#given the avd name, avd root directory and tools root directory, creates an avd that can be run from the cloud
create_default_avd()
{
	#check that avd name and avd root directory are given
	if [ $# -ne 3 ];
	then
		echo "Please provide name of avd and directory of packages."
		return 20
	fi

	sys_im_dir="$2/system-images/android-25/google_apis/arm64-v8a"
	package="system-images;android-25;google_apis;arm64-v8a"

	if [ ! -d $sys_im_dir ];
	then
		echo "$sys_im_dir not found. Installing package '$package'."
		#install the package
		sdkmanager --install $package
	fi

	avd_name=$1
	avd_dir="$3/$avd_name.avd"

	if ! $( mkdir -p $avd_dir ); then
		return 1
	fi

	#create avd
	#sdcard size 512M
	#tag google_apis
	#abi arm64-v8a
	#device id 19
	avdmanager create avd -n $avd_name -c "512M" -k $package -g "google_apis" -b "arm64-v8a" -d 19 -f -p $avd_dir
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
		return 1
	fi

	avdmanager delete avd -n $1
	echo "Deleted avd '$1'"
	return $?
}

#starts an emulator given an avd name and root folder for all avds
start_avd()
{
	if [ $# -ne 1 ];
	then
		echo "Failed to start emulator. Please provide avd name."
		return 1
	fi
#	if [ $# -ne 3 ];
#	then
#		echo "Failed to start emulator. Please provide avd name, root directory for avds and sdk root directory."
#		return 1
#	fi
#
#	if [ ! -d $2 ];
#	then
#		echo "Invalid directory '$2'."
#		return 1
#	fi
#
#	if [ ! -d "$2/$1" ];
#	then
#		echo "Invalid directory '$2/$1'."
#		return 1
#	fi
#
#	if [ ! -d "$3" ];
#	then
#		echo "Invalid directory '$3'."
#		return 1
#	fi
	
	#sys_dir="$3/system-images/android-25/google_apis/arm64-v8a"

	emulator @$1 -gpu swiftshader_indirect -memory 512 -no-window -no-boot-anim -no-audio -no-snapshot -camera-front none -camera-back none -wipe-data -no-qt #-sysdir $sys_dir -datadir "$2/$1" -kernel "$sys_dir/kernel-qemu" -ramdisk "$sys_dir/ramdisk.img" -system "$sys_dir/system.img" -init-data "$2/$1/userdata.img" 
	return $?
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
		echo "Provide avd name for deletion."
		return 1
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

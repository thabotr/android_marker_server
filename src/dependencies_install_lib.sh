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

	export PATH="$PATH:$1/emulator" # export the emulator folder into which the emulator binary resides
}

#given the avd name, avd root directory and tools root directory, creates an avd that can be run from the cloud
create_default_avd()
{
	#check that avd name and avd root directory are given
	if [ $# -ne 3 ];
	then
		echo "Please provide name of avd, directory into which created avd will be stored, and directory of packages."
		return 20
	elif [ ! -d $2 ];
	then
		echo "$2 does not exist."
		return 20
	fi

	sys_im_dir="$3/system-images/android-25/google_apis/arm64-v8a"
	package="system-images;android-25;google_apis;arm64-v8a"

	if [ ! -d $sys_im_dir ];
	then
		echo "$sys_im_dir not found. Installing package '$package'."
		#install the package
		sdkmanager --install $package
	fi

	avd_name=$1
	avd_root_dir="$2/$avd_name" #avd directory seems to get deleted when we delete avd, so we give each avd its unique directory
	mkdir $avd_root_dir #make the location directory for the avd
	
	#create avd
	#sdcard size 512M
	#tag google_apis
	#abi arm64-v8a
	#device id 19
	avdmanager create avd -n $avd_name -c "512M" -k $package -g "google_apis" -b "arm64-v8a" -p $avd_root_dir -d 19 -f
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

#starts an emulator given an avd name
start_emulator()
{
	if [ $# -ne 1 ]; then
		echo "Failed to start emulator. Please provide avd name."
		return 1
	fi

	emulator @$1 -gpu swiftshader_indirect -memory 512 -no-window -no-boot-anim -no-audio -net-delay none -no-snapshot -camera-front none -camera-back none -wipe-data
	emulator 
	return $?
}

#sets and exports a list of avds
get_list_of_avds()
{
	avdList=($( emulator -list-avds | tr '\n' '\n'))
	export avdList
}

#deletes all provided avds else just deletes all of them
delete_avds()
{
	if [ $# -ne 1 ];
	then
		echo "AVD names not provided. Deleting all avds."
		#get list of avds
		get_list_of_avds
		#then delete all avds
		for avd in ${avdList[@]}
		do
			delete_avd $avd
		done
	elif [ $# -eq 1 ];
	then
		for avd in ${$1[@]}
		do
			delete_avd $avd
		done
	fi
}

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
		find $MARKER_TOOLS
	fi

	avd_name=$1
	avd_root_dir=$2
	
	#create avd
	#sdcard size 512M
	#tag google_apis
	#abi arm64-v8a
	#device id 19
	avdmanager create avd -n $avd_name -c "512M" -k $package -g "google_apis" -b "arm64-v8a" -p $avd_root_dir -d 19 -f
}

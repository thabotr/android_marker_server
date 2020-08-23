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
	
	#make dir android_sdk/cmdline-tools inside the root directory
	mkdir "$1/cmdline-tools"

	#unzip and put in correct directories
	unzip -q -d "$1/cmdline-tools" commandline*.zip

	#clean up
	rm commandline*.zip

	#TODO export to path some important directories
	#export bin directory to path
	export PATH=$PATH:"$( echo $1/cmdline-tools/**/bin)":"$( echo $1/cmdline-tools/tools/)"
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
	sdkmanager install emulator
}

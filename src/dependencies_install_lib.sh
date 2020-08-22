#this script will define functions to install android dependencies

#install gradle into the given directory
install_gradle()
{
	echo $1
	return 1
	#check that extraction directory is provided
	[ ! -d $1 ] && echo "Please provide directory in which to install gradle." && return 20

	#download the gradle zip
	wget https://downloads.gradle-dn.com/distributions/gradle-6.6-bin.zip
	#unzip gradle into provided directory
	unzip -d $1 gradle*.zip
	#remove downloaded zip
	rm gradle*.zip

	#export gradle bin to path
	export PATH=$PATH:$1/**/bin
}

#install java version 8
#will do a minimal install of java jvm and noGUI support
install_java()
{
	sudo apt install openjdk-8-jre-headless
}

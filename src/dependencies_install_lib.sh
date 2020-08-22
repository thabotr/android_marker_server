#this script will define functions to install android dependencies

#install gradle given the version 
install_gradle()
{
	
	echo $#
}

#install java version 8
#will do a minimal install of java jvm and noGUI support
install_java()
{
	sudo apt install openjdk-8-jre-headless
}

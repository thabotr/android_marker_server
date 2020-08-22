#this script create the necessary directories for running android marker, you can change the environment vars if need be

#root directory for most of the components used for maintaining the marker
MARKER_TOOLS="$HOME/marker_tools"

#gradle directory
GRADLE="$MARKER_TOOLS/gradle"

#sdk location
ANDROID_HOME="$MARKER_TOOLS/android_sdk"

#make the essential directories
mkdir $MARKER_TOOLS $GRADLE

#install all the necessary dependencies
#components java-8
#gradle 6.6

#import installation functions
source ./src/dependencies_install_lib.sh

#install java 8
install_java

#install gradle 6.6
install_gradle $GRADLE

#install android sdk
install_sdk $ANDROID_HOME
#export android home variable to path
export ANDROID_HOME

#list contents of current directory
#find $MARKER_TOOLS

#run sdk manager
sdkmanager --version

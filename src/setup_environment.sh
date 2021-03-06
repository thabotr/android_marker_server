#this script create the necessary directories for running android marker, you can change the environment vars if need be

#root directory for most of the components used for maintaining the marker
MARKER_TOOLS="$HOME/marker_tools"
export MARKER_TOOLS

#gradle directory
GRADLE="$MARKER_TOOLS/gradle"

#sdk location
ANDROID_HOME="$MARKER_TOOLS/android_sdk"

#avd locations
AVD_HOME="$MARKER_TOOLS/.android/avd"

#make the essential directories
mkdir -p $MARKER_TOOLS $GRADLE $ANDROID_HOME $AVD_HOME

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

#install emulator
install_emulator $ANDROID_HOME
export AVD_HOME
export ANDROID_SDK_ROOT=$ANDROID_HOME

#move android directory
cp -R "$HOME/.android" -t $MARKER_TOOLS
rm -rf "$HOME/.android"

export ANDROID_EMULATOR_HOME="$MARKER_TOOLS/.android"
export ANDROID_AVD_HOME="$ANDROID_EMULATOR_HOME/avd"

#install platform tools to use adb
install_platform_tools $ANDROID_HOME

export AVD_LOGS="$ANDROID_AVD_HOME/logs" #make logging directory for emulators
mkdir -p $AVD_LOGS

#gradle basics
mkdir basic-demo
cd basic-demo
echo 2 | gradle init

ls -l

#create_default_avd 80 $ANDROID_HOME $ANDROID_AVD_HOME
#	start_avd 80 $AVD_LOGS
#
#	adb -s 'emulator-5634' wait-for-device
#	#check that device is not booted
#	#by name
#	! avd_boot_complete 'emulator-5634' $AVD_LOGS 
#	#by id
#	! avd_boot_complete 80 $AVD_LOGS
#
#	sleep 184
#	
#	#check that the device is fully booted
#	#by name
#	avd_boot_complete 'emulator-5634' $AVD_LOGS
#	avd_boot_complete 80 $AVD_LOGS

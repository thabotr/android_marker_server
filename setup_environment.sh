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
source ./android_cmline_lib.sh

#install java 11
install_java

#install android sdk
get_commandline_tools
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

export AVD_LOGS="$ANDROID_AVD_HOME/logs" #make logging directory for emulators
mkdir -p $AVD_LOGS
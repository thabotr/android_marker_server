export MARKER_TOOLS="$HOME/marker_tools"
#sdk location
export ANDROID_SDK_ROOT="$MARKER_TOOLS/android_sdk"

#avd location
export ANDROID_AVD_HOME="$MARKER_TOOLS/.android/avd"

mkdir -p $MARKER_TOOLS $ANDROID_SDK_ROOT $ANDROID_AVD_HOME

cd $MARKER_TOOLS

export ANDROID_EMULATOR_HOME="$MARKER_TOOLS/.android"
export ANDROID_AVD_HOME=$AVD_HOME

#move android avds directory
#cp -R "$HOME/.android" -t $MARKER_TOOLS
#rm -rf "$HOME/.android"

export AVD_LOGS="$ANDROID_AVD_HOME/logs"
mkdir -p $AVD_LOGS

#install sdk
wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip

unzip -q -d $ANDROID_SDK_ROOT commandline*.zip
rm *.zip
#export PATH=$PATH:"$ANDROID_HOME/cmdline-tools/bin" #sdk location
#
##for now list versions so we know what build tools to get
yes | $ANDROID_SDK_ROOT/cmdline-tools/bin/sdkmanager --licenses > /dev/null
#
$ANDROID_SDK_ROOT/cmdline-tools/bin/sdkmanager "emulator" "platform-tools"> /dev/null #platform tools for adb

find .

##add emulator directory to path so we can use bin emulator
#export PATH=$PATH:"$MARKER_TOOLS/android_sdk/emulator":"$MARKER_TOOLS/android_sdk/platform-tools"
#
##install emulator package
#sdkmanager --install "system-images;android-28;default;x86_64"
#
#pwd
#find .
#
#echo no | avdmanager create avd -f -n emulator1 -c "512M" -k "system-images;android-28;default;x86_64"
#
#emulator @emulator1 -gpu swiftshader_indirect -memory 512 -no-window -no-boot-anim -no-audio -no-snapshot -camera-front none -camera-back none -selinux permissive -no-qt -wipe-data -no-accel

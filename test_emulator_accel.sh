export MARKER_TOOLS="$HOME/marker_tools"
#sdk location
export ANDROID_SDK_ROOT="$MARKER_TOOLS/android_sdk"
export ANDROID_SDK_HOME="$MARKER_TOOLS/android_avd"
export ANDROID_EMULATOR_HOME="$ANDROID_SDK_HOME/.android"
export ANDROID_AVD_HOME="$ANDROID_EMULATOR_HOME/avd" #avd data files

#make relevant directories
mkdir -p $MARKER_TOOLS $ANDROID_SDK_ROOT $ANDROID_AVD_HOME

cd $MARKER_TOOLS

#install sdk
wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip

unzip -q commandline*.zip
rm *.zip
mkdir "$ANDROID_SDK_ROOT/cmdline-tools"
mv cmdline-tools tools
mv tools -t "$ANDROID_SDK_ROOT/cmdline-tools"

#accept licenses
( yes || true ) | $ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager --licenses > /dev/null

#getting latest sdk
$ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager --install "cmdline-tools;latest"
rm -rf $ANDROID_SDK_ROOT/cmdline-tools/tools  #removing tools directory in orde rto use latest sdk tools, NB: mayb break as new sdk updates and changes arrive
export PATH=$PATH:"$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

sdkmanager --install "platform-tools" > /dev/null
sdkmanager --install "build-tools;30.0.3" > /dev/null
sdkmanager --install "emulator" > /dev/null

export PATH=$PATH:"$ANDROID_SDK_ROOT/emulator":"$ANDROID_SDK_ROOT/platform-tools"
#install image package
sdkmanager --install "system-images;android-28;default;x86_64"
sdkmanager --install "platforms;android-28" #solves SDK installation not found problem

echo no | avdmanager create avd -f -n emulator1 -c "512M" -k "system-images;android-28;default;x86_64"

emulator @emulator1 -gpu swiftshader_indirect -memory 512 -no-window -no-boot-anim -no-audio -no-snapshot -camera-front none -camera-back none -selinux permissive -no-qt -wipe-data -no-accel -sysdir "$ANDROID_SDK_ROOT/system-images/android-28/default/x86_64" #sysdir solves broken AVD path problem as by default the sys images are searched for in emulator dir

adb devices

export MARKER_TOOLS="$HOME/marker_tools"
#sdk location
export ANDROID_SDK_ROOT="$MARKER_TOOLS/android-sdk-linux"

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

unzip -q commandline*.zip
rm *.zip
mkdir "$ANDROID_SDK_ROOT/cmdline-tools"
mv cmdline-tools -t "$ANDROID_SDK_ROOT/cmdline-tools"

export PATH=$PATH:"$ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools/bin" #sdkmanager location

#accept licenses
yes | sdkmanager --licenses > /dev/null

#install emulator for starting avds and platform tools for adb
sdkmanager "emulator" "platform-tools"> /dev/null
export PATH=$PATH:"$ANDROID_SDK_ROOT/emulator":"$ANDROID_SDK_ROOT/platform-tools"

#install image package
sdkmanager --install "system-images;android-28;default;x86_64"

echo no | avdmanager create avd -f -n emulator1 -c "512M" -k "system-images;android-28;default;x86_64" -p "$ANDROID_AVD_HOME"

find .

emulator @emulator1 -gpu swiftshader_indirect -memory 512 -no-window -no-boot-anim -no-audio -no-snapshot -camera-front none -camera-back none -selinux permissive -no-qt -wipe-data -no-accel

export MARKER_TOOLS="$HOME/marker_tools"
#sdk location
export ANDROID_HOME="$MARKER_TOOLS/android_sdk"
#avd location
export AVD_HOME="$MARKER_TOOLS/.android/avd"

mkdir -p $MARKER_TOOLS $ANDROID_HOME $AVD_HOME

cd $MARKER_TOOLS

#move android avds directory
cp -R "$HOME/.android" -t $MARKER_TOOLS
rm -rf "$HOME/.android"

export ANDROID_EMULATOR_HOME="$MARKER_TOOLS/.android"
export AANDROID_AVD_HOME=$AVD_HOME

export AVD_LOGS="$ANDROID_AVD_HOME/logs"
mkdir -p $AVD_LOGS

#install sdk
wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip

mkdir cmdline-tools

unzip -q -d android_sdk commandline*.zip

rm commandline*.zip

#place sdk under tools
mv android_sdk/* -t $ANDROID_HOME
rm android_sdk

export PATH=$PATH:$ANDROID_HOME/cmdline-tools/bin:$ANDROID_HOME/tools
#sdk location

#for now list versions so we know what build tools to get
yes | sdkmanager --licenses > /dev/null

sdkmanager "emulator" > /dev/null #"tools" "platform-tools" > /dev/null

#add emulator directory to path so we can use bin emulator
export PATH=$PATH:"$ANDROID_HOME/emulator"

#install emulator package
sdkmanager --install "system-images;android-28;default;x86_64"

echo no | avdmanager create avd -f -n emulator1 -c "512M" -k "system-images;android-28;default;x86_64"

find .

emulator @emulator1 -gpu swiftshader_indirect -memory 512 -no-window -no-boot-anim -no-audio -no-snapshot -camera-front none -camera-back none -selinux permissive -no-qt -wipe-data -no-accel

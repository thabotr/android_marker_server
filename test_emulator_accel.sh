source set_env_vars.bash
set_var_marker_tools
set_var_android_sdk_root
set_var_android_sdk_home
set_var_android_emulator_home
set_var_android_avd_home

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
export_latest_tools_bin

sdkmanager --install "platform-tools" > /dev/null
sdkmanager --install "build-tools;30.0.3" > /dev/null
sdkmanager --install "emulator" > /dev/null

export_amulator
export_platform_tools

#install image package
sdkmanager --install "system-images;android-28;default;x86_64"
sdkmanager --install "platforms;android-28" #solves SDK installation not found problem

echo no | avdmanager create avd -f -n emulator1 -c "512M" -k "system-images;android-28;default;x86_64"

emulator @emulator1 -gpu swiftshader_indirect -memory 512 -no-window -no-boot-anim -no-audio -no-snapshot -camera-front none -camera-back none -selinux permissive -no-qt -wipe-data -no-accel -sysdir "$ANDROID_SDK_ROOT/system-images/android-28/default/x86_64" 2>&1 > /dev/null & #sysdir solves broken AVD path problem as by default the sys images are searched for in emulator dir

adb wait-for-device

adb devices

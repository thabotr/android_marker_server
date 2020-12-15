source set_env_vars.bash || ( echo "ERROR! ENVIROMENT VARIABLES NOT SET." && exit 1 )
set_var_marker_tools
set_var_android_sdk_root
set_var_android_sdk_home
set_var_android_emulator_home
set_var_android_avd_home

#make relevant directories
mkdir -p $MARKER_TOOLS $ANDROID_SDK_ROOT $ANDROID_AVD_HOME

#change into tools directory
cd $MARKER_TOOLS

find ../

source ../sdk_lib.bash || ( echo "ERROR! SDK library could not be sourced to install SDK." && exit 1 )
get_commandline_tools

source ../emulator_manager_lib.bash || ( echo "ERROR! Emulator manager library could not be sourced." && exit 1 )
install_emulator_image "28" "default" "x86_64"

echo no | avdmanager create avd -f -n emulator1 -c "512M" -k "system-images;android-28;default;x86_64"

emulator @emulator1 -gpu swiftshader_indirect -memory 512 -no-window -no-boot-anim -no-audio -no-snapshot -camera-front none -camera-back none -selinux permissive -no-qt -wipe-data -no-accel -sysdir "$ANDROID_SDK_ROOT/system-images/android-28/default/x86_64" 2>&1 > /dev/null & #sysdir solves broken AVD path problem as by default the sys images are searched for in emulator dir

adb wait-for-device

adb devices

adb -s emulator-5554 shell getprop

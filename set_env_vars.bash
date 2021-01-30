#this script is to be sourced by most of the other scripts and tools
#these are global environment variables to be used by the marker tools
#please note that any changes to these variables may affect other variables and functioning of certain tools and scripts

set_var_marker_tools()
{
	export MARKER_TOOLS="$HOME/marker_tools"
}
export -f set_var_marker_tools

set_var_gradle()
{
	set_var_marker_tools
	export GRADLE="$MARKER_TOOLS/gradle"
}
export -f set_var_gradle

set_var_android_sdk_root()
{
	set_var_marker_tools
	export ANDROID_SDK_ROOT="$MARKER_TOOLS/android_sdk"
}
export -f set_var_android_sdk_root

set_var_android_sdk_home()
{
	set_var_marker_tools
	export ANDROID_SDK_HOME="$MARKER_TOOLS/android_avd"
}
export -f set_var_android_sdk_home

set_var_android_emulator_home()
{
	ser_var_android_sdk_home
	export ANDROID_EMULATOR_HOME="$ANDROID_SDK_HOME/.android"
}
export -f set_var_android_emulator_home

set_var_android_avd_home()
{
	set_var_android_emulator_home
	export ANDROID_AVD_HOME="$ANDROID_EMULATOR_HOME/avd"
}
export -f set_var_android_avd_home

export_latest_tools_bin()
{
	set_var_android_sdk_root
	export PATH=$PATH:"$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
}
export -f export_latest_tools_bin

export_emulator()
{
	set_var_android_sdk_root
	#allows us to use emulator binary
	export PATH=$PATH:"$ANDROID_SDK_ROOT/emulator"
}
export -f export_emulator

export_platform_tools()
{
	set_var_android_sdk_root
	#allows us to use adb binary
	export PATH=$PATH:"$ANDROID_SDK_ROOT/platform-tools"
}
export -f export_platform_tools

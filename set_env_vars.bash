#this script is to be sourced by most of the other scripts and tools
#these are global environment variables to be used by the marker tools
#please note that any changes to these variables may affect other variables and functioning of certain tools and scripts

set_var_marker_tools()
{
	export MARKER_TOOLS="$HOME/marker_tools"
}

set_var_android_sdk_root()
{
	export ANDROID_SDK_ROOT="$MARKER_TOOLS/android_sdk"
}

set_var_android_sdk_home()
{
	export ANDROID_SDK_HOME="$MARKER_TOOLS/android_avd"
}

set_var_android_emulator_home()
{
	export ANDROID_EMULATOR_HOME="$ANDROID_SDK_HOME/.android"
}

set_var_android_avd_home()
{
	export ANDROID_AVD_HOME="$ANDROID_EMULATOR_HOME/avd"
}

export_latest_tools_bin()
{
	export PATH=$PATH:"$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"
}
export_amulator()
{
	#allows us to use emulator binary
	export PATH=$PATH:"$ANDROID_SDK_ROOT/emulator"
}

export_platform_tools()
{
	#allows us to use adb binary
	export PATH:$PATH:"$ANDROID_SDK_ROOT/platform-tools"
}

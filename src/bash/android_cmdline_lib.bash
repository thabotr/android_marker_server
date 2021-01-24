#requires that the folliwng vars are defined ANDROID_SDK_ROOT and set_env_vars has been sourced
#installs android sdk tools and exports emulator and platform tools
get_commandline_tools()
{
	#get commandline tools
	wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip

	unzip -q commandline*.zip
	rm *.zip
	mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools"
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
	
	export_emulator
	export_platform_tools
}

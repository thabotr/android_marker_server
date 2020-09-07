#!/usr/bash/env bats

source ./src/dependencies_install_lib.sh

@test "Can start an emulator" {
	#create an emulator
	create_default_avd 0 $ANDROID_HOME $ANDROID_AVD_HOME
	
	#start emulator
	start_avd 0 $AVD_LOGS

	loud_wait_for_device
	adb devices >&3 #printing online devices
}

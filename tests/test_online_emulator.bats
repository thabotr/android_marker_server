#!/usr/bash/env bats

source ./src/dependencies_install_lib.sh

@test "Can start an emulator" {
	#create an emulator
	create_default_avd "myAVD" $ANDROID_HOME $ANDROID_AVD_HOME
	
	#start emulator
	start_avd "myAVD"

	adb devices >&3 #printing online devices

	loud_wait_for_emulator >&3
}

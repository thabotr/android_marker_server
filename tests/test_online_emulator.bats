#!/usr/bash/env bats

@test "Can start an emulator" {
	#create an emulator
	create_default_avd "myAVD" $ANDROID_HOME $ANDROID_AVD_HOME
	
	#start emulator
	
}

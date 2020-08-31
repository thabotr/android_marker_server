#!/usr/bash/env bats

@test "Can start an emulator" {
	skip "Wanna fix all tests up to 11 for now."
	#create an emulator
	create_default_avd "myAVD" $ANDROID_HOME $ANDROID_AVD_HOME
	
	#start emulator
	
}

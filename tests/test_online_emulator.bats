#!/usr/bash/env bats

source ./src/dependencies_install_lib.sh

@test "Can return an empty list when no avd online." {
	get_list_of_online_avds
	#ensure list is empty
	[ ${#onlineAvdList[@]} == 0 ]
}

@test "Can start an emulator and update list of online avds accordingly." {
	#create an emulator
	create_default_avd 0 $ANDROID_HOME $ANDROID_AVD_HOME
	
	#start emulator
	start_avd 0 $AVD_LOGS

	loud_wait_for_emulator
	
	get_list_of_online_avds
	#ensure list is of size 1
	[ ${#onlineAvdList[@]} == 1 ]

	#ensure emulator name is 'emulator-5554', port 5554 is assigned for emulator of id 0
	[[ ${onlineAvdList[0]} == "emulator-5554" ]]
}

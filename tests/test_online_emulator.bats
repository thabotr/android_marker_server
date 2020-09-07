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

@test "Can start multiple avds and ensure avd list updated successfully." {
	create_default_avd 2 $ANDROID_HOME $ANDROID_AVD_HOME
	create_default_avd 4 $ANDROID_HOME $ANDROID_AVD_HOME
	create_default_avd 6 $ANDROID_HOME $ANDROID_AVD_HOME

	start_avd 2 $AVD_LOGS
	start_avd 4 $AVD_LOGS
	start_avd 6 $AVD_LOGS

	loud_wait_for_emulator

	#compare names
	names=( "emulator-5554" "emulator-5556" "emulator-5558" "emulator-55560" )
	for name in ${onlineAvdList[@]};
	do
		echo ${names[@]} | grep $name #search for each name
	done
}

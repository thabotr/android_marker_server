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

	loud_wait_for_emulator >&3
	
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

	loud_wait_for_emulator 'emulator-5560' >&3

	#compare names
	names=( "emulator-5554" "emulator-5556" "emulator-5558" "emulator-5560" )
	get_list_of_online_avds
	echo "List of currently online avds ${onlineAvdList[@]}"
	for name in ${onlineAvdList[@]};
	do
		echo ${names[@]} | grep $name #search for each name
	done
}

@test "Can assess whether emulator has fully booted." {
	create_default_avd 80 $ANDROID_HOME $ANDROID_AVD_HOME
	start_avd 80 $AVD_LOGS

	adb -s 'emulator-5634' wait-for-device
	#check that device is not booted
	#by name
	! avd_boot_complete 'emulator-5634' $AVD_LOGS 
	#by id
	! avd_boot_complete 80 $AVD_LOGS

	sleep 184
	
	#check that the device is fully booted
	#by name
	avd_boot_complete 'emulator-5634' $AVD_LOGS >&3
	avd_boot_complete 80 $AVD_LOGS
}

@test "Can wait for one emulator, by id, to boot." {
	create_default_avd 82 $ANDROID_HOME $ANDROID_AVD_HOME
	start_avd 82 $AVD_LOGS

	adb -s 'emulator-5636' wait-for-device
	#check that device is not booted
	#by name
	! avd_boot_complete 'emulator-5636' $AVD_LOGS
	#by id
	! avd_boot_complete 82 $AVD_LOGS

	#use wait function and pass avd id
	wait_for_avds $AVD_LOGS 82
	
	#check that the device is fully booted
	#by name
	avd_boot_complete 'emulator-5636' $AVD_LOGS
	avd_boot_complete 82 $AVD_LOGS
}

@test "Can wait for one emulator, by name, to boot." {
	create_default_avd 84 $ANDROID_HOME $ANDROID_AVD_HOME
	start_avd 84 $AVD_LOGS

	adb -s 'emulator-5638' wait-for-device
	#check that device is not booted
	#by name
	! avd_boot_complete 'emulator-5638' $AVD_LOGS
	#by id
	! avd_boot_complete 84 $AVD_LOGS

	#use wait function and pass avd id
	wait_for_avds $AVD_LOGS 84
	
	#check that the device is fully booted
	#by name
	avd_boot_complete 'emulator-5638' $AVD_LOGS
	avd_boot_complete 84 $AVD_LOGS
}


#testing avd emulator range
#create_default_avd 80 $ANDROID_HOME $ANDROID_AVD_HOME
#start_avd 80 $AVD_LOGS
#
#adb devices
#adb wait-for-device
#adb devices
#
#cat "/home/travis/marker_tools/.android/avd/logs/emulator-5634.log"
#
#sleep 184
#
#cat "/home/travis/marker_tools/.android/avd/logs/emulator-5634.log"
#
#adb -s 'emulator-5634' shell 'pm list packages -f'
#

#!/usr/bin/env bats

@test "Ensures there aren't any avds already created. This is good for ensuring we can autocreate avds." {
	#skip "We don't want to get rid of already existing avds."
	if avd_exists ;then
		exit 1
	fi
}

@test "Ensures avd of id '0' is created." {
	create_default_avd 0 $ANDROID_HOME $ANDROID_AVD_HOME #we rely on the source of the set_environ script to have worked
	if ! avd_exists 0 ;then
		exit 1 # avd created but not found
	fi
}

@test "Can create and delete avd of id '0'." {
	create_default_avd 0 ANDROID_HOME $ANDROID_AVD_HOME #we rely on the source of the set_environ script to have worked
	if ! avd_exists 0 ;then
		exit 1
	fi
	
	if ! delete_avd 0 ;then
		exit 1
	fi

	if avd_exists 0 ;then
		exit 1 #failed to delete created avd
	fi
}

@test "Can return a list 'avdList' of avds of length 0 when no avds created." {
	get_list_of_avds
	[ ${#avdList[@]} == 0 ] #length of list should be 0
}

@test "Can return a list of avds with ids corresponding to created ones." {
	create_default_avd 2 $ANDROID_HOME $ANDROID_AVD_HOME
	create_default_avd 4 $ANDROID_HOME $ANDROID_AVD_HOME
	create_default_avd 6 $ANDROID_HOME $ANDROID_AVD_HOME
	create_default_avd 8 $ANDROID_HOME $ANDROID_AVD_HOME
	
	get_list_of_avds
	[ ${#avdList[@]} == 4 ]

	#compare names
	names=( 2 4 6 8 )
	for name in ${avdList[@]};
	do
		echo ${names[@]} | grep $name #search for each name
	done
}

@test "Can delete a range of emulators." {
	#this test is dependent on the previous one
	get_list_of_avds
	[ ${#avdList[@]} -eq 4 ]

	create_default_avd 10 $ANDROID_HOME $ANDROID_AVD_HOME
	create_default_avd 12 $ANDROID_HOME $ANDROID_AVD_HOME
	create_default_avd 14 $ANDROID_HOME $ANDROID_AVD_HOME
	
	get_list_of_avds
	[ ${#avdList[@]} -eq 7 ]

	#compare names
	names=( 10 12 14 2 4 6 8 )
	for name in ${avdList[@]};
	do
		echo ${names[@]} | grep $name #search for each name
	done

	#delete some avds by name
	avds=( 2 8 )

	delete_avds ${avds[@]}
	
	#ensure the deleted avds don't exist
	! avd_exists 2
	! avd_exists 8
	
	get_list_of_avds

	#ensures the undeleted avds exist
	avds=( 4 6 10 12 14 )
	avds_exist ${avds[@]}

	#deletes all remaining avds
	delete_avds "all_avds"

	#ensures no avds exist
	! avd_exists
}

#!/usr/bin/env bats

source src/dependencies_install_lib.sh

@test "Ensures there aren't any avds already created. This is good for ensuring we can autocreate avds." {
	#skip "We don't want to get rid of already existing avds."
	if avd_exists ;then
		exit 1
	fi
}

@test "Ensures avd of name 'myAVD' is created." {
	create_default_avd "myAVD" $AVD_HOME $ANDROID_HOME #we rely on the source of the set_environ script to have worked
	if ! avd_exists "myAVD" ;then
		exit 1 # avd created but not found
	fi
}

@test "Can create and delete avd of name 'myAVD'." {
	create_default_avd "myAVD" $AVD_HOME $ANDROID_HOME #we rely on the source of the set_environ script to have worked
	if ! avd_exists "myAVD" ;then
		exit 1
	fi
	
	if ! delete_avd "myAVD" ;then
		exit 1
	fi

	if avd_exists "myAVD" ;then
		exit 1 #failed to delete created avd
	fi
}

@test "Can return a list 'avdList' of avds of length 0 when no avds created." {
	get_list_of_avds
	[ ${#avdList[@]} == 0 ] #length of list should be 0
}

@test "Can return a list of avds with names corresponding to created ones." {
	create_default_avd "avd1" $AVD_HOME $ANDROID_HOME
	create_default_avd "avd2" $AVD_HOME $ANDROID_HOME
	create_default_avd "avd3" $AVD_HOME $ANDROID_HOME
	create_default_avd "avd4" $AVD_HOME $ANDROID_HOME
	
	get_list_of_avds
	[ ${#avdList[@]} == 4 ]

	#compare names
	names=( avd1 avd2 avd3 avd4 )
	for name in ${avdList[@]};
	do
		echo ${names[@]} | grep $name #search for each name
	done
}

@test "Can delete a range of emulators." {
	#this test is dependent on the previous one
	get_list_of_avds
	[ ${#avdList[@]} -eq 4 ]

	create_default_avd "avd10" $AVD_HOME $ANDROID_HOME
	create_default_avd "avd11" $AVD_HOME $ANDROID_HOME
	create_default_avd "avd12" $AVD_HOME $ANDROID_HOME
	
	get_list_of_avds
	[ ${#avdList[@]} -eq 7 ]

	#compare names
	names=( avd1 avd10 avd11 avd12 avd2 avd3 avd4 )
	for name in ${avdList[@]};
	do
		echo ${names[@]} | grep $name #search for each name
	done

	#delete some avds by name
	avds=( avd1 avd4 )

	delete_avds ${avds[@]}
	
	#ensure the deleted avds don't exist
	! avd_exists avd1
	! avd_exists avd4

	#ensures the undeleted avds exist
	avds=( avd2 avd3 avd10 avd11 avd12 )
	for avd in ${avds[@]}
	do
		avd_exists $avd
	done
}

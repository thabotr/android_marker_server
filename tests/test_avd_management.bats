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

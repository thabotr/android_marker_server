#!/usr/bin/env bats

source src/dependencies_install_lib.sh

@test "Ensures there aren't any avds already created. This is good for ensuring we can autocreate avds." {
	#skip "We don't want to get rid of already existing avds."
	[ ! avd_exists ]
}

@test "Ensures avd of name 'myAVD' is created." {
	create_default_avd "myAVD" $AVD_HOME $ANDROID_HOME #we rely on the source of the set_environ script to have worked
	[ avd_exists "myAVD" ]
}

@test "Can create and delete avd of name 'myAVD'." {
	create_default_avd "myAVD" $AVD_HOME $ANDROID_HOME #we rely on the source of the set_environ script to have worked
	[ avd_exists "myAVD" ]
	delete_avd "myAVD"
	[ ! avd_exists "myAVD" ]
}

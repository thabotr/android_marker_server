#!/usr/bin/env bats

source src/dependencies_install_lib.sh

@test "Ensures there aren't any avds already created. This is good for ensuring we can autocreate avds." {
	#skip "We don't want to get rid of already existing avds."
	result="$( avdmanager list avds)"
	[[ ! "$result" == *"Name:"* ]] #appearance of the words 'Name:' means there's an existing avd created, hence we fail.
}

@test "Ensures avd of name 'myAVD' is created." {
	create_default_avd "myAVD" $AVD_HOME $ANDROID_HOME #we rely on the source of the set_environ script to have worked
	result="$( avdmanager list avds)"
	[[ "$result" == *"myAVD"* ]]
}

@test "Just show whats on the marker folder" {
	find $MARKER_TOOLS >&3
}

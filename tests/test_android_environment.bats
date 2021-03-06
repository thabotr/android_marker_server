#!/usr/bin/env bats

@test "Java version 8 exists on system" {
	result="$(java -version 2>&1)"
	[[ "$result" == *"version \"1.8"* ]] #< if the command above passed and returns string with substring version "1.8...
	echo "# $result" >&3 #printing java version to screen
}

@test "Gradle version 6 exists on system" {
	result="$( gradle -version)"
	[[ "$result" == *"Gradle 6."* ]]
	echo "# $result" >&3 #printing gradle version to screen
}

@test "SDK manager installed" {
	result="$( sdkmanager --version)"
	[[ "$result" == *"4."* ]] #FIXME highly depends on version, breaks if version five is installed
	echo "# $result" >&3 #printing sdk version to screen
}

@test "Emulator package is installed" {
	result="$( emulator -version 2>&1| head -n 1 | cat)" # line will never return an error due to pipe
	[[ ! "$result" == *"command not found"* ]] #ensure the previous call for version did not fail
	echo "# $result" >&3 #printing emulator version to screen
}

@test "ADB installed" {
	result="$( adb version)"
	[[ "$result" == *"Version"* ]]
	echo "# $result" >&3 #printing adb version to screen
}

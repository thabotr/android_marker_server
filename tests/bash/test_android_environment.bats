#!/usr/bin/env bats
@test "SDK manager installed" {
	result="$( sdkmanager)"
	[[ "$result" == *"Usage:"* ]] #checking if help returned usage iformation as expected.
	echo "# sdkmanager version '$( sdkmanager --version )'" >&3 #printing sdk version to screen
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

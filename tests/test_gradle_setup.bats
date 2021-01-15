#!/usr/bin/env bats

@test "Java exists on system" {
	result="$(java -version 2>&1)"
	[[ "$result" == *"openjdk"* ]] #< if the command above passed and returns string with substring version "1.8...
	echo "# $result" >&3 #printing java version to screen
}

@test "Gradle exists on system" {
	result="$( gradle -version)"
	[[ "$result" == *"Gradle"* ]]
	echo "# $result" >&3 #printing gradle version to screen
}

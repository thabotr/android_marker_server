#!/usr/bin/env bats

@test "Java version 8 exists on system" {
	result="$(java -version 2>&1)"
	[[ "$result" == *"version \"1.8"* ]] #< if the command above passed and returns string with substring version "1.8...
}

@test "Gradle version 6 exists on system" {
	result="$( gradle -version)"
	[[ "$result" == *"Gradle 6."* ]]
}

@test "SDK manager installed" {
	result="$( sdkmanager --version)"
	[[ "$result" == *"30."* ]]
}

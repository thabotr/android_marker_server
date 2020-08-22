#!/usr/bin/env bats

@test "Java version 8 exists on system" {
	result="$(java -version)"
	[[ $result =~ "1.8" ]] #< if the command above passed and returns strign with substring "1.8"
}

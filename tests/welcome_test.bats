#!/usr/bin/env bats

@test "addition using bc" {
	result="$(echo 4 + 4 | bc)"
	[ "$result" -eq 8 ]
}

@test "must not fail test" {
	[ 2 -eq 2 ]
}

@test "must skip test" {
	skip "We do as we're told."
}

@test "Test functions in seperate scripts" {
	source ./src/hello_world.bash #< import script
	
	result="$(welcome 'Thabo')"
	[[ "$result" == "Welcome, Thabo!" ]]
}

@test "Testing boolean functions." {
	[ bool_func hello ]
}

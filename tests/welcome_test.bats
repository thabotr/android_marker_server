#!/usr/bin/env bats

@test "addition using bc" {
	result="$(echo 4 + 4 | bc)"
	[ "$result" -eq 8 ]
}

@test "must fail test" {
	[ 1 -eq 2 ]
}

@test "must skip test" {
	skip "We do as we're told."
}

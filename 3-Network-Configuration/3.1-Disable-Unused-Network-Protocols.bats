#!/usr/bin/env bats

@test "3.1.1 Disable IPv6 (Manual)" {
    skip "This audit has to be done manually"
}

@test "3.1.2 Ensure wireless interfaces are disabled (Automated)" {
    run "$BATS_TEST_DIRNAME"/3.1.2.sh
    [ "$status" -eq 0 ]
    [ "$output" = "Wireless is not enabled" ]
}

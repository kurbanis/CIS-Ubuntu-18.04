#!/usr/bin/env bats

@test "5.2.1 Ensure sudo is installed (Automated)" {
    run bash -c "dpkg -s sudo"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Status: install ok installed"* ]]
}

@test "5.2.2 Ensure sudo commands use pty (Automated)" {
    run bash -c "grep -Ei '^\s*Defaults\s+([^#]+,\s*)?use_pty' /etc/sudoers /etc/sudoers.d/*"
    [ "$status" -eq 0 ]
    [[ "$output" == *":Defaults	use_pty"* ]]
}

@test "5.2.3 Ensure sudo log file exists (Automated)" {
    run bash -c "grep -Ei '^\s*Defaults\s+logfile=\S+' /etc/sudoers /etc/sudoers.d/*"
    [ "$status" -eq 0 ]
    [[ "$output" == *":Defaults"*"logfile="* ]]
}
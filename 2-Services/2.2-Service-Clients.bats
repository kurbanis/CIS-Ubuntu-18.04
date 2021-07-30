#!/usr/bin/env bats

@test "2.2.1 Ensure NIS Client is not installed (Automated)" {
    run bash -c "dpkg -s nis | grep -E '(Status:|not installed)'"
    [ "$status" -eq 1 ]
}

@test "2.2.2 Ensure rsh client is not installed (Automated)" {
    run bash -c "dpkg -s rsh-client | grep -E '(Status:|not installed)'"
    [ "$status" -eq 1 ]
}

@test "2.2.3 Ensure talk client is not installed (Automated)" {
    run bash -c "dpkg -s talk | grep -E '(Status:|not installed)'"
    [ "$status" -eq 1 ]
}

@test "2.2.4 Ensure telnet client is not installed (Automated)" {
    run bash -c "dpkg -s telnet | grep -E '(Status:|not installed)'"
    [ "$status" -eq 1 ]
}

@test "2.2.5 Ensure LDAP client is not installed (Automated)" {
    run bash -c "dpkg -s ldap-utils | grep -E '(Status:|not installed)'"
    [ "$status" -eq 1 ]
}

@test "2.2.6 Ensure RPC client is not installed (Automated)" {
    run bash -c "dpkg -s rpcbind | grep -E '(Status:|not installed)'"
    [ "$status" -eq 1 ]
}
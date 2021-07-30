#!/usr/bin/env bats

@test "5.7 Ensure access to the su command is restricted (Automated)" {
    run bash -c "grep \"auth required pam_wheel.so use_uid group=\" /etc/pam.d/su"
    [ "$status" -eq 0 ]
    [[ "$output" == "auth required pam_wheel.so use_uid group="* ]]
    local GROUP=(${output//auth required pam_wheel.so use_uid group=/ }) # get the group name from the string
    [[ "$GROUP" != "" ]]
    run bash -c "grep $GROUP /etc/group"
    [ "$status" -eq 0 ]
    [[ "$output" == "$GROUP:"*":"*":" ]]
}
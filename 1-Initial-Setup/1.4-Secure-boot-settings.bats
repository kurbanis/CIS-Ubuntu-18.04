#!/usr/bin/env bats

@test "1.4.1 Ensure permissions on bootloader config are not overridden (Automated)" {
    run bash -c "grep -E '^\s*chmod\s+[0-7][0-7][0-7]\s+\$\{grub_cfg\}\.new' -A 1 -B1 /usr/sbin/grub-mkconfig"
    [ "$status" -eq 0 ]
    [[ "$output" = *"chmod 400 ${grub_cfg}.new"* ]]
}

@test "1.4.2 Ensure bootloader password is set (Automated)" {
    (grep '^set superusers' /boot/grub/grub.cfg)
    (grep "^password" /boot/grub/grub.cfg)
}

@test "1.4.3 Ensure permissions on bootloader config are configured (Automated)" {
    run bash -c "stat /boot/grub/grub.cfg | grep '^Access: (0400'"
    [ "$status" -eq 0 ]
}

@test "1.4.4 Ensure authentication required for single user mode (Automated)" {
    run bash -c "grep -Eq '^root:\$[0-9]' /etc/shadow"
    [ "$status" -ne 0 ]
}
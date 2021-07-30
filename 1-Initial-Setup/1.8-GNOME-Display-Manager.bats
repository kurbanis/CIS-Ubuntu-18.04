#!/usr/bin/env bats

@test "1.8.1 Ensure GNOME Display Manager is removed (Manual)" {
    run bash -c "dpkg -s gdm3 | grep -E '(Status:|not installed)'"
    [ "$status" -eq 1 ]
}

@test "1.8.2 Ensure GDM login banner is configured (Automated)" {
    run bash -c "cat /etc/gdm3/greeter.dconf-defaults | grep '^[^#;]' | grep 'banner-message-enable=true'"
    [ "$status" -eq 0 ]
    run bash -c "cat /etc/gdm3/greeter.dconf-defaults | grep '^[^#;]' | grep 'banner-message-text='"
    [ "$status" -eq 0 ]
}

@test "1.8.3 Ensure disable-user-list is enabled (Automated)" {
    run bash -c "cat /etc/gdm3/greeter.dconf-defaults | grep '^[^#;]' | grep 'disable-user-list=true'"
    [ "$status" -eq 0 ]
}

@test "1.8.4 Ensure XDCMP is not enabled (Automated)" {
    run bash -c "cat /etc/gdm3/custom.conf | grep '^[^#;]' | grep -i 'enable=true'"
    [ "$status" -eq 1 ]
}
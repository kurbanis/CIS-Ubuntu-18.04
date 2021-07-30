#!/usr/bin/env bats

@test "1.3.1 Ensure AIDE is installed (Automated)" {
    run bash -c "dpkg -s aide | grep -E '(Status:|not installed)"
    [ "$status" -eq 0 ]
    [[ "$output" = "Status: install ok installed" ]]
    run bash -c "dpkg -s aide-common | grep -E '(Status:|not installed)"
    [ "$status" -eq 0 ]
    [[ "$output" = "Status: install ok installed" ]]
}

@test "1.3.2 Ensure filesystem integrity is regularly checked (Automated)" {
    local check_enabled
    local check_status

    if systemctl is-enabled aidecheck.service; then
        check_enabled=$(systemctl is-enabled aidecheck.service)
        check_status=$(systemctl status aidecheck.service)
    else
        check_enabled=false
        check_status=false
    fi

    local timer_enabled
    local timer_status
    if systemctl is-enabled aidecheck.timer; then
        timer_enabled=$(systemctl is-enabled aidecheck.timer)
        timer_status=$(systemctl status aidecheck.timer)
    else
        timer_enabled=false
        timer_status=false
    fi;

    local aide_in_root_cron
    if crontab -u root -l; then
        aide_in_root_cron=$(crontab -u root -l | grep aide)
    else
        aide_in_root_cron=false
    fi;

    local aide_in_any_cron
    aide_in_any_cron=$(grep -r aide /etc/cron.* /etc/crontab)

    [ "$check_enabled" != false ] && [ "$check_status" != false ] &&
     [ "$timer_enabled" != false ] && [ "$timer_status" != false ] \
      || [ "$aide_in_root_cron" ] \
      || [ "$aide_in_any_cron" ]
}


@test "5.5.1.1 Ensure minimum days between password changes is configured (Automated)" {
    run bash -c "grep PASS_MIN_DAYS /etc/login.defs | grep --invert-match \"\#\""
    [ "$status" -eq 0 ]
    [[ "$output" != "" ]]
    MINDAYS=(${output//PASS_MIN_DAYS/ }) # get the number from the string
    [[ "$MINDAYS" -gt 0 ]]
    run bash -c "grep -E ^[^:]+:[^\!*] /etc/shadow | cut -d: -f1,4"
    [ "$status" -eq 0 ]
    while IFS=: read -r line; do
        MINDAYS=(${line//:/ }) # get the number from the string
        [[ "${MINDAYS[1]}" -gt 0 ]]
    done <<< "$output"
}

@test "5.5.1.2 Ensure password expiration is 365 days or less (Automated)" {
    run bash -c "grep PASS_MAX_DAYS /etc/login.defs | grep --invert-match \"\#\""
    [ "$status" -eq 0 ]
    [[ "$output" != "" ]]
    MAXDAYS=(${output//PASS_MAX_DAYS/ }) # get the number from the string
    [[ "$MAXDAYS" -lt 366 ]]
    run bash -c "grep -E '^[^:]+:[^!*]' /etc/shadow | cut -d: -f1,5"
    [ "$status" -eq 0 ]
    while IFS=: read -r line; do
        MAXDAYS=(${line//:/ }) # get the number from the string
        [[ "${MAXDAYS[1]}" -lt 366 ]]
    done <<< "$output"
}

@test "5.5.1.3 Ensure password expiration warning days is 7 or more (Automated)" {
    run bash -c "grep PASS_WARN_AGE /etc/login.defs | grep --invert-match \"\#\""
    [ "$status" -eq 0 ]
    [[ "$output" != "" ]]
    WARNAGE=(${output//PASS_WARN_AGE/ }) # get the number from the string
    [[ "$WARNAGE" -gt 6 ]]
    run bash -c "grep -E ^[^:]+:[^\!*] /etc/shadow | cut -d: -f1,6"
    [ "$status" -eq 0 ]
    while IFS=: read -r line; do
        WARNAGE=(${line//:/ }) # get the number from the string
        [[ "${WARNAGE[1]}" -gt 6 ]]
    done <<< "$output"
}

@test "5.5.1.4 Ensure inactive password lock is 30 days or less (Automated)" {
    run bash -c "useradd -D | grep INACTIVE"
    [ "$status" -eq 0 ]
    [[ "$output" != "" ]]
    INACTIVE=(${output//INACTIVE=/ }) # get the number from the string
    [[ "$INACTIVE" != -1 ]]
    [[ "$INACTIVE" -lt 31 ]]
    run bash -c "grep -E ^[^:]+:[^\!*] /etc/shadow | cut -d: -f1,7"
    [ "$status" -eq 0 ]
    while IFS=: read -r line; do
        INACTIVE=(${line//:/ }) # get the number from the string
        [[ "${INACTIVE[1]}" != "" ]]
        [[ "${INACTIVE[1]}" -lt 31 ]]
    done <<< "$output"
}

@test "5.5.1.5 Ensure all users last password change date is in the past (Automated)" {
    run bash -c 'awk -F: '\''{print $1}'\'' /etc/shadow | while read -r usr; do [[ $(date --date="$(chage --list "$usr" | grep '\''^Last password change'\'' | cut -d: -f2)" +%s) > $(date +%s) ]] && echo "$usr last password change was: $(chage --list "$usr" | grep '\''^Last password change'\'' | cut -d: -f2)"; done'
    [[ "$output" == "" ]]
}

@test "5.5.2 Ensure system accounts are secured (Automated)" {
    run bash -c '\''awk -F: '\''($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $1!~/^\+/ && $3<'\''"$(awk '\''/^\s*UID_MIN/{print $2}'\'' /etc/login.defs)"'\'' && $7!="'\''"$(which nologin)"'\''" && $7!="/bin/false") {print}'\'' /etc/passwd'
    [[ "$output" == "" ]]
    run bash -c 'awk -F: '\''($1!="root" && $1!~/^\+/ && $3<'\''"$(awk '\''/^\s*UID_MIN/{print $2}'\'' /etc/login.defs)"'\'') {print $1}'\'' /etc/passwd | xargs -I '\''{}'\'' passwd -S '\''{}'\'' | awk '\''($2!="L" && $2!="LK") {print $1}'\'''
    [[ "$output" == "" ]]
}

@test "5.5.3 Ensure default group for the root account is GID 0 (Automated)" {
    run bash -c "grep "^root:" /etc/passwd | cut -f4 -d:"
    [ "$status" -eq 0 ]
    [[ "$output" == "0" ]]
}

@test "5.5.4 Ensure default user umask is 027 or more restrictive (Automated)" {
    run "$BATS_TEST_DIRNAME"/5.5.4.sh
    [ "$status" -eq 0 ]
    [[ "$output" == "Default user umask is set" ]]

    run bash -c "grep -RPi '(^|^[^#]*)\s*umask\s+([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b|[0-7][01][0-7]\b|[0-7][0-7][0-6]\b|(u=[rwx]{0,3},)?(g=[rwx]{0,3},)?o=[rwx]+\b|(u=[rwx]{1,3},)?g=[^rx]{1,3}(,o=[rwx]{0,3})?\b)' /etc/login.defs /etc/profile* /etc/bash.bashrc*"
    [ "$status" -eq 1 ]
    [[ "$output" == "" ]]
}

@test "5.5.5 Ensure default user shell timeout is 900 seconds or less (Automated)" {
    run "$BATS_TEST_DIRNAME"/5.5.5.sh
    [ "$status" -eq 0 ]
    [[ "$output" != "FAILED"* ]]
}
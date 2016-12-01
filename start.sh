#!/bin/bash
export $BASEDIRECTORY=/opt/dck1c
source /opt/dck1c/config.sh
source /opt/dck1c/lib/ansiesc.sh
source /opt/dck1c/lib/utils.sh

print_banner

USEXTERM=${DCK1C_XTERM+false}
if [[ "$1" == "xterm" ]] && [[ ! "${USEXTERM}" ]]; then
    env DCK1C_XTERM=true xterm -e /bin/bash -c "/opt/dck1c/start.sh"
    exit $?
fi

if [[ $DCK1C_AUTOSTART_CLIENT ]]; then
    nohup /opt/1C/v8.3/x86_64/1cv8 &> /dev/null &
fi
sleep 3
while [[ "" == "" ]]; do
    dialog --no-ok --no-cancel --menu "dck1C" 14 50 50 "OneMore" "Запустить ещё одну 1С" "ListAll" "Сеансы" "Bash" "Запустить bash shell" "Kill" "Завершить один" "KillAll" "Завершить все" "Kill&Exit" "Завершить все и выйти" 2> /tmp/dresult.out
    dresult=$(cat /tmp/dresult.out) && rm -f /tmp/dresult.out
    if [[ $dresult == "OneMore" ]]; then
        nohup /opt/1C/v8.3/x86_64/1cv8 &> /dev/null &
    fi
    if [[ $dresult == "ListAll" ]]; then
        prc_tbl=$(get_prc_table)
        printf "$prc_tbl" | xargs dialog --no-ok --menu "Сеансы" 20 70 70 "$1" "$*" 2> /tmp/pid.out
        kresult=$(cat /tmp/pid.out) && rm -f /tmp/pid.out
    fi
    if [[ $dresult == "Bash" ]]; then
        bash
    fi
    if [[ $dresult == "Kill" ]]; then
        prc_tbl=$(get_prc_table)
        printf "$prc_tbl" | xargs dialog --no-ok --menu "Kill <?>" 20 70 70 "$1" "$*" 2> /tmp/pid.out
        kresult=$(cat /tmp/pid.out) && rm -f /tmp/pid.out
        kill $kresult
    fi
    if [[ $dresult == "KillAll" ]]; then
        for p in $(pgrep 1cv8); do kill $p; done;
    fi
    if [[ $dresult == "Kill&Exit" ]]; then
        for p in $(pgrep 1cv8); do kill $p; done;
        clear
        exit 0
    fi
    clear
done

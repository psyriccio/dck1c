#!/bin/bash

function get_prc_table() {
    for p in $(pgrep 1cv8); do
        echo $p
        echo $(ps -p $p -F h | awk '{ print $1"@"$2":"$12 }')
    done
}

nohup /opt/1C/v8.3/x86_64/1cv8 &> /dev/null &
printf "dck1c started!\n"
while [[ true ]]; do
    dialog --no-ok --no-cancel --menu "dck1C" 12 50 50 "OneMore" "Запустить ещё одну 1С" "ListAll" "Сеансы" "Bash" "Запустить bash shell" "Kill" "Завершить один" "KillAll" "Завершить все" "Kill&Exit" "Завершить все и выйти" 2> /tmp/dresult.out
    dresult=$(cat /tmp/dresult.out) && rm -f /tmp/dresult.out
    if [[ $dresult == "OneMore" ]]; then
        nohup /opt/1C/v8.3/x86_64/1cv8 &> /dev/null &
    fi
    if [[ $dresult == "ListAll" ]]; then
        for p in $(pgrep 1cv8); do
            ps -p $p -F
        done
        echo "-----"
        printf "Нажмите <enter> для продолжения\n"
        read
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

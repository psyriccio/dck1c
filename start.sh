#!/bin/bash

export TERM=xterm-color

function print_banner() {
    printf "${_LWHT} _______   ______  __  ___  __    ______ ${_NA}\n"
    printf "${_LWHT}|       \ /      ||  |/  / /_ |  /      |${_NA}\n"
    printf "${_LWHT}|  .--.  |  ,----'|  '  /   | | |  ,----'${_NA}\n"
    printf "${_LWHT}|  |  |  |  |     |    <    | | |  |     ${_NA}\n"
    printf "${_LWHT}|  '--'  |  \`----.|  .  \   | | |  \`----.${_NA}\n"
    printf "${_LWHT}|_______/ \______||__|\__\\  |_|  \______|${_NA}\n\n"
    printf "${_LWHT}\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D"
    printf "\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D"
    printf "\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D${_NA}\n"
    printf "${_LWHT}     1C docker container builder${_NA}\n"
    printf "${_LWHT}_________________________________________${_NA}\n"
}

function get_prc_table() {
    for p in $(pgrep 1cv8); do
        echo $p
        echo $(ps -p $p -F h | awk '{ print $1"@"$2":"$12 }')
    done
}

USEXTERM=${DCK1C_XTERM+false}
if [[ "$1" == "--xterm" ]] && [[ ! "${USEXTERM}" ]]; then
    env DCK1C_XTERM=true xterm -e /bin/bash -c "/opt/dck1c/start.sh"
    exit $?
fi

print_banner
nohup /opt/1C/v8.3/x86_64/1cv8 &> /dev/null &
while [[ "" == "" ]]; do
    dialog --no-ok --no-cancel --menu "dck1C" 14 50 50 "OneMore" "Запустить ещё одну 1С" "ListAll" "Сеансы" "Bash" "Запустить bash shell" "Kill" "Завершить один" "KillAll" "Завершить все" "Kill&Exit" "Завершить все и выйти" 2> /tmp/dresult.out
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

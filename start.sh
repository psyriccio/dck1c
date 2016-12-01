#!/bin/bash
source /opt/dck1c/config.sh
source /opt/dck1c/lib/ansiesc.sh
source /opt/dck1c/lib/utils.sh

export TERM=xterm-color

function print_banner() {
    printf "\n\n"
    printf "${_BLU}         88            88               ${_LYLW}88   ,ad8888ba,   ${_NA}\n"
    printf "${_BLU}         88            88             ${_LYLW},d88  d8\"\'    \`\"8b  ${_NA}\n"
    printf "${_BLU}         88            88           ${_LYLW}888888 d8\'            ${_NA}\n"
    printf "${_BLU} ,adPPYb,88  ,adPPYba, 88   ,d8         ${_LYLW}88 88             ${_NA}\n"
    printf "${_BLU}a8\"    \`Y88 a8\"     \"\" 88 ,a8\"          ${_LYLW}88 88             ${_NA}\n"
    printf "${_BLU}8b       88 8b         8888[            ${_LYLW}88 Y8,            ${_NA}\n"
    printf "${_BLU}\"8a,   ,d88 \"8a,   ,aa 88\`\"Yba,         ${_LYLW}88  Y8a.    .a8P  ${_NA}\n"
    printf "${_BLU} \`\"8bbdP\"Y8  \`\"Ybbd8\"\' 88   \`Y8a        ${_LYLW}88   \`\"Y8888Y\"\'   ${_NA}\n"
    printf "\n"
    printf "${_LWHT}                              1C docker container builder${_NA}\n\n"
}

function get_prc_table() {
    for p in $(pgrep 1cv8); do
        echo $p
        echo $(ps -p $p -F h | awk '{ print $1"@"$2":"$12 }')
    done
}

print_banner

USEXTERM=${DCK1C_XTERM+false}
if [[ "$1" == "--xterm" ]] && [[ ! "${USEXTERM}" ]]; then
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

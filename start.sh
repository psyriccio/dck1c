#!/bin/bash
export BASEDIRECTORY=/opt/dck1c
export DIALOG_OK=0
export DIALOG_CANCEL=1
export DIALOG_EXTRA=2
source $BASEDIRECTORY/config.sh
source $BASEDIRECTORY/lib/ansiesc.sh
source $BASEDIRECTORY/lib/utils.sh
source $BASEDIRECTORY/lib/1c.sh

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
    dialog --no-ok --no-cancel --menu "dck1C" 14 50 50 "Run" "Запустить 1С" "Sessions" "Сеансы" "Bash" "Запустить bash shell" "Tools" "Инструменты" "Kill&Exit" "Завершить все и выйти" 2> /tmp/dresult.out
    dresult=$(cat /tmp/dresult.out) && rm -f /tmp/dresult.out
    if [[ $dresult == "Run" ]]; then
        nohup /opt/1C/v8.3/x86_64/1cv8 &> /dev/null &
    fi
    if [[ $dresult == "Sessions" ]]; then
        prc_tbl=$(get_prc_table)
        printf "$prc_tbl" | xargs dialog --no-ok --menu "Сеансы" 20 70 70 "$1" "$*" 2> /tmp/pid.out
        krescode=$?
        kresult=$(cat /tmp/pid.out) && rm -f /tmp/pid.out
        if (( $krescode == 123 )); then
            kill $kresult
        fi
    fi
    if [[ $dresult == "Bash" ]]; then
        bash
    fi
    if [[ $dresult == "Tools" ]]; then
        dialog --no-ok --no-cancel --menu "dck1C - Tools" 14 50 50 "Conf" "Конфигурация" "DB" "БД" 2> /tmp/dresult.out
        tresult=$(cat /tmp/dresult.out) && rm -f /tmp/dresult.out
        if [[ $tresult == "Conf" ]]; then
            dialog --no-ok --no-cancel --menu "dck1C - Tools" 14 50 50 "Write" "Сохранить в файл" "Read" "Загрузить из файла" "Dump" "Выгрузить в файлы" "Load" "Загрузить из файлов"  2> /tmp/dresult.out
            tresult=$(cat /tmp/dresult.out) && rm -f /tmp/dresult.out
            if [[ $tresult ==  "Write" ]]; then
                cfflname="/tmp/"$(date +%Y%m%d_%H%M%S)".$c1connection_server.$c1connection_database.cf"
                printf "Writing configuration %s...\n" $cfflname
                write_configuration "$cfflname"
                exit 0
            fi
            if [[ $tresult == "Read" ]]; then
                exit 0
            fi
            if [[ $tresult == "Dump" ]]; then
                exit 0
            fi
            if [[ $tresult == "Load" ]]; then
                exit 0
            fi
        fi
        if [[ $tresult == "DB" ]]; then
            exit 0
        fi
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

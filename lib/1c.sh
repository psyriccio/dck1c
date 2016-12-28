#!/bin/bash
function get_1c_bases() {
    cat ~/.1C/1cestart/ibases.v8i | grep -E "\[(.*)\]" | sed -r "s/\[|\]//g"
}

function get_base_info() { # $1 - base name
    cat ~/.1C/1cestart/ibases.v8i | grep -zo -E "\[$1][^\[]*(\[)|($)" | sed -r "s/\[.*//g"
}

function get_base_property() { # $1 - base name; $2 - property name
    get_base_info $1 | grep -E "^$2=" | sed -r "s/$2=//g"
}

function ask_password() {
    resultsfile="/tmp/"$(uuid)
    dialog --clear --passwordbox "$1" 10 50 2> "$resultsfile"
    export c1connection_password=$(cat "$resultsfile")
    rm -f "$resultsfile"
}

function base_connection_setup() {
    if [[ -z "$c1connection_server" ]]; then
        export c1connection_server="localhost"
    fi
    if [[ -z "$c1connection_database" ]]; then
        export c1connection_database="db"
    fi
    if [[ -z "$c1connection_user" ]]; then
        export c1connection_user="user"
    fi
    resultsfile="/tmp/"$(uuid)
    dialog --form "Соединение с базой" 10 50 3 "      Сервер:" 0 0 "$c1connection_server" 0 14 30 30 "      Имя БД:" 2 0 "$c1connection_database" 2 14 30 30 "Пользователь:" 3 0 "$c1connection_user" 3 14 30 30 2> $resultsfile
    res=($(cat "$resultsfile"))
    rm -f "$resultsfile"
    export c1connection_server=$(echo $res[1])
    export c1connection_database=$(echo $res[2])
    export c1connection_user=$(echo $res[3])
    ask_password "Пароль для $c1connection_user@$c1connection_server/$c1connection_database"
}

function construct_base_connection_string() {
    if [[ -z "$c1connection_server" ]]; then
        base_connection_setup
    fi
    if [[ -z "$c1connection_password" ]]; then
        ask_password "Пароль для $c1connection_user@$c1connection_server/$c1connection_database"
    fi
    printf " /S \"%s\\%s\" /IBName \"%s\" /N \"%s\" /P \"%s\" " $c1connection_server $c1connection_database $c1connection_database $c1connection_user $c1connection_password
    unset $c1connection_password
}

function write_configuration() {
    /opt/1C/v8.3/x86_64/1cv8 $(construct_base_connection_string) "/DumpCfg $1"
}

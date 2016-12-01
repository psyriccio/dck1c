#!/bin/bash

source $BASEDIRECTORY/lib/ansiesc.sh

export TERM=xterm-color

function get_prc_table() {
    for p in $(pgrep 1cv8); do
        echo $p
        echo $(ps -p $p -F h | awk '{ print $1"@"$2":"$12 }')
    done
}

_VERSION=$(cat $BASEDIRECTORY/VERSION)

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
    printf "                 ${_LWHT}%40s${_NA}\n" "1C docker container"
    printf "                 ${_LGRE}%40s${_NA}\n" ${_VERSION}
    printf "                 ${_LGRE}%40s${_NA}\n\n" "pltf."${DCK1C_1CPLATFORM_VERSION}
}

# show errror message ($1) and exit with exit code #############################
# calculated from error message hash
function error_exit() {
    printf "\n\n${_LRED}$1${_NA}\n\n"
    exit_code=$(echo $1 | sum -s | awk '{ print $1 }')
    exit $exit_code
}
################################################################################

#!/bin/bash

source ./ansiesc.sh

# show errror message ($1) and exit with exit code #############################
# calculated from error message hash
function error_exit() {
    printf "\n\n${_LRED}$1${_NA}\n\n"
    exit_code=$(echo $1 | sum -s | awk '{ print $1 }')
    exit $exit_code
}
################################################################################

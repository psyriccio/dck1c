#!/bin/bash
################################################################################
# color constants
#   foreground
_ESC='\033['; _NA=$_ESC'0m'
_GRE=$_ESC'0;30m'; _RED=$_ESC'0;31m'; _GRN=$_ESC'0;32m'; _YLW=$_ESC'0;33m'
_BLU=$_ESC'0;34m'; _MAG=$_ESC'0;35m'; _CYA=$_ESC'0;36m'; _WHT=$_ESC'0;37m'
_LGRE=$_ESC'1;30m'; _LRED=$_ESC'1;31m'; _LGRN=$_ESC'1;32m'; _LYLW=$_ESC'1;33m'
_LBLU=$_ESC'1;34m'; _LMAG=$_ESC'1;35m'; _LCYA=$_ESC'1;36m'; _LWHT=$_ESC'1;37m'
################################################################################
#   background
_BGRE=$_ESC'0;40m'; _BRED=$_ESC'0;41m'; _BGRN=$_ESC'0;42m'; _BYLW=$_ESC'0;43m'
_BBLU=$_ESC'0;44m'; _BMAG=$_ESC'0;45m'; _BCYA=$_ESC'0;46m'; _BWHT=$_ESC'0;47m'
_BLGRE=$_ESC'1;40m'; _BLRED=$_ESC'1;41m'; _BLGRN=$_ESC'1;42m'; _BLYLW=$_ESC'1;43m'
_BLBLU=$_ESC'1;44m'; _BLMAG=$_ESC'1;45m'; _BLCYA=$_ESC'1;46m'; _BLWHT=$_ESC'1;47m'
################################################################################

# cursor movement directions ###################################################
_UP='A'; _DWN='B'; _FWD='C', _BCK='D'
################################################################################

# move cursor $1 - direction, $2 - count #######################################
function _CUR_MOVE() {
    _res=$_ESC$2$1
    printf $_res
}
################################################################################

# sets cursor position $1 - line, $2 - column ##################################
function _CUR_SET() {
    _res=$_ESC$1$2'H'
    printf $_res
}
################################################################################

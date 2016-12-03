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

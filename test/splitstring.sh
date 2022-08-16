#!/usr/bin/env bash

function _split {
    parts=$(echo $1 | tr "_" "\n")
    
    for part in $parts
    do
        echo "> [$part]"
    done
    echo "======================"
}

fileName="Escape_to_the_Country_Series_19_-_68._Aberdeenshire_m000cfqf_original"

_split $fileName

fileName="Top_of_the_Pops_-_18_03_1993_m0018zsw_original"

_split $fileName

value=0
[ $value -eq 1 ] && echo "Hello"

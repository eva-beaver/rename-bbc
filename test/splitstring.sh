#!/bin/bash

function _split {
    declare -a parts=($(echo $1 | tr "_" "\n"))
    
    echo ${#parts[*]}
    
    echo "${#parts[3]}"
    
    len=${#parts[@]}
    
    echo $len
    for part in "${parts[@]}"
    do
        echo "> [$part]"
    done
    
    echo "======================"
}

function _split1 {
    declare -a parts=($(echo $1 | tr "_" "\n"))
    
    echo ${#parts[*]}
    
    echo "${#parts[3]}"
    
    length=${#parts[@]}
    
    echo $length
    
    for (( j=0; j<length; j++ ));
    do
        printf "Current index %d with value %s\n" $j "${parts[$j]}"
    done
    
    echo "======================"
}

function _split2 {
    parts=$(echo $1 | tr "_" "\n")
    
    echo ${#parts[*]}
    
    echo "${#parts[3]}"
    
    len=${#parts[@]}
    
    echo $len
    
    for part in $parts
    do
        echo "> [$part]"
    done
    
    echo "======================"
}

fileName="Escape_to_the_Country_Series_19_-_68._Aberdeenshire_m000cfqf_original"

_split1 $fileName

fileName="Top_of_the_Pops_-_18_03_1993_m0018zsw_original"

_split1 $fileName

value=0
[ $value -eq 1 ] && echo "Hello"

MODE="A"

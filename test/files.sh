#!/usr/bin/env bash

DoIt() (

    echo "-------DoIt----------------"

    local _locarray=()

    # Add new element at the end of the array

    # Iterate the directory contents and add to local array
    for value in "${tmparray[@]}"
    do
        _locarray+=("$value")
        echo "Added $value"
    done

    echo "-----------------------"

    # Iterate the loop to read and print each array element
    for value in "${_locarray[@]}"
    do
        echo $value
        echo "stat $dir/$value"
        stat "$dir/$value"
        echo "================================================"
    done

    echo ${_locarray[0]}
    echo "-----------------------"
    echo ${_locarray[1]}
    echo "${_locarray[@]}"

)

dir=$1

i=0
while read line
do
    tmparray[ $i ]="$line"  
    (( i++ ))
done < <(ls $1)

echo ${tmparray[1]}
echo ${tmparray[2]}

echo "+++++++++++++++++++++++++++++++++++++++"
echo "+++++++++++++++++++++++++++++++++++++++"

DoIt

exit 0

echo "-----------------------"

files=($1/*)


echo ${files[1]}
echo ${files[2]}

echo ${files[@]}

echo "-----------------------"

OIFS=$IFS
IFS=$'\n'
array=($(ls -ls  -Q --quoting-style escape  $1))
IFS=$OIFS
echo "${array[1]}"
echo "${array[2]}"
echo "${array[3]}"
echo "${array[@]}"

echo "-----------------------"

IFS=' ' read -r -a array <<< $(ls $1)

echo "${array[1]}"
echo "${array[2]}"
echo "${array[3]}"
echo "${array[@]}"


echo "-----------------------"
echo "-----------------------"
echo "-----------------------"

DoIt


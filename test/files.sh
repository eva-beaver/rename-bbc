#!/usr/bin/env bash

DoIt() (

echo "-------DoIt----------------"

local array1=()

# Add new element at the end of the array

# Iterate the loop to read and print each array element
for value in "${array[@]}"
do
    array1+=("$value")
     echo $value
done

echo "-----------------------"

# Iterate the loop to read and print each array element
for value in "${array1[@]}"
do
     echo $value
done

echo ${array1[0]}
echo "-----------------------"
echo ${array1[1]}
echo "${array1[@]}"

)

i=0
while read line
do
    array[ $i ]="$line"  
    (( i++ ))
done < <(ls -ls $1)

echo ${array[1]}
echo ${array[2]}

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

DoIt
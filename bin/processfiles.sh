#!/usr/bin/env bash

listdir()
{
	local currentPath=$1 prefix="$2"
	local -a currentDir=($(ls -Q --quoting-style escape $1))
	local -i lastIndex=$((${#currentDir[*]} - 1)) index

	for ((index=0; index<lastIndex; index++))
	do
		printf "%s├─%s\n" "$prefix" ${currentDir[$index]} 
		echo ">>>>>> ${currentDir[$index]}"
		if [ -d "$currentPath/${currentDir[$index]}" ]; then
			listdir "$currentPath/${currentDir[$index]}" "$prefix""│ "
		fi	
	done

	if [ $lastIndex -ge 0 ]; then
		printf "%s└─%s\n" "$prefix" ${currentDir[$lastIndex]}
		if [ -d "$currentPath/${currentDir[$index]}" ]; then
			listdir "$currentPath/${currentDir[$index]}" "$prefix""  "
		fi
	fi
}

listdir $1 ''

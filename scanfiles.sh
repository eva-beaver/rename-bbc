#!/bin/bash

#Scan a directory recurisivly and report on contents

# ./scanfiles.sh /mnt/share/allmovies/backup-3/X 0000 [Red]
# ./scanfiles.sh /mnt/share/movies/2021-01-January-1/ 0000 [Red]
# sudo ./scanfiles.sh /mnt/share/backup-3/Movies12 0000 [Red]

# sudo mount.cifs //192.168.1.130/backup-3 /mnt/share/backup-3/ -o user=xxx,pass=xxx

UNIQID=$2

logDir="./log"
fileDir="./files"

#////////////////////////////////
function _writeLog {

    echo $1
    echo $1 >> ./log/scanfiles-log-$UNIQID.txt

}

#////////////////////////////////
function _writeErrorLog {

    echo $1 >> ./log/scanfiles-error-$UNIQID.txt

}

#////////////////////////////////
_processfile()
{
    printf "$1/$2\n"  >> $UNIQID-files.txt
}

#////////////////////////////////
_processdir()
{
	local currentPath=$1 prefix="$2"

    tmparray=()

    i=0
    while read line
    do
        tmparray[ $i ]="$line"  
        (( i++ ))
    done < <(ls "$1")

    local currentDir=()

    # Iterate the directory contents and add to local array
    for value in "${tmparray[@]}"
    do
        currentDir+=("$value")
        #echo "Added $value"
    done

	#local -a currentDir=($(ls -Q --quoting-style escape $1))
	local -i lastIndex=$((${#currentDir[*]} - 1)) index

	for ((index=0; index<lastIndex; index++))
	do
		printf "$prefix├─${currentDir[$index]}\n"
		#printf "%s├─%s\n" $prefix "${currentDir[$index]}" 
		#echo ">>>>>> ${currentDir[$index]}"
		if [ -d "$currentPath/${currentDir[$index]}" ]; then
			_processdir "$currentPath/${currentDir[$index]}" "$prefix""│ "
        else
    		_processfile "$currentPath/" "${currentDir[$index]}"
		fi	
	done

	if [ $lastIndex -ge 0 ]; then
		printf "$prefix└─${currentDir[$lastIndex]}\n"
		#printf "%s└─%s\n" "$prefix" ${currentDir[$lastIndex]}
		if [ -d "$currentPath/${currentDir[$index]}" ]; then
			_processdir "$currentPath/${currentDir[$index]}" "$prefix""  "
        else
    		#printf "$currentPath/${currentDir[$index]}\n"  >> $UNIQID-files.txt
    		_processfile "$currentPath/" "${currentDir[$index]}"
		fi
	fi
}

PASSED=$1

if [ -d "${PASSED}" ] ; then
    echo "$PASSED is a directory";
else
    if [ -f "${PASSED}" ]; then
        echo "${PASSED} is a file";
    else
        echo "${PASSED} is not valid";
        exit 1
    fi
fi

# Check files directory
if [ -d "${logDir}" ] ; then
    echo "$logDir directory exists";
else
    echo "$logDir does exist, creating";
    mkdir $logDir
fi

# Check log directory
if [ -d "${fileDir}" ] ; then
    echo "$fileDir directory exists";
else
    echo "$fileDir does exist, creating";
    mkdir $fileDir
fi

_writeLog "Starting"
_writeLog "========================================="

dirCnt=0
movCnt=0
existCnt=0
errCnt=0
cnt=0

_processdir "$PASSED"

_writeLog "========================================="
_writeLog "Number of input movies $cnt"
_writeLog "Number of directories created $dirCnt"
_writeLog "Number of movies moved $movCnt"
_writeLog "#########################################"
_writeLog "Number of directories with issues $existCnt"
_writeLog "Number of movie directories with issues $errCnt"
_writeLog "========================================="

_writeLog "Complete"

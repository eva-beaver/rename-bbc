#!/usr/bin/env bash
#/*
#* Copyright 2014-2022 the original author or authors.
#*
#* Licensed under the Apache License, Version 2.0 (the "License");
#* you may not use this file except in compliance with the License.
#* You may obtain a copy of the License at
#*
#*     http://www.apache.org/licenses/LICENSE-2.0
#*
#* Unless required by applicable law or agreed to in writing, software
#* distributed under the License is distributed on an "AS IS" BASIS,
#* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#* See the License for the specific language governing permissions and
#* limitations under the License.
#*/

. $(dirname $0)/bin/_vars.sh
. $(dirname $0)/bin/_logging.sh

#////////////////////////////////
function __getFileExt()
{
    CURRFileExtension=${CURRFULLFILENAME:$((len-3)):3}
    
}

#////////////////////////////////
function __getFileName()
{
    CURRFILENAME=${CURRFULLFILENAME:0:$((len-4))}
    
}

#////////////////////////////////
function __checkFileType {
    case "$CURRFileExtension" in
        mp4*)     echo "mp4" ;;
        mp3*)     echo "mp3" ;;
        mkv*)     echo "mkv" ;;
        *)        echo "unknown: $CURRFileExtension" ;;
    esac
}

#////////////////////////////////
function __getMediaInfo()
{
    
    __getFileExt "$2"
    __getFileName "$2"
    local __IsValid=__checkFileType
    
    __mediadetails=$(mediainfo --output=JSON "$1$2"  |  jq '. | {'"$items"'}');
    
    printf "$__mediadetails\n"  >> "$FULLFILEDIR"$TOKEN-mediaDetails.txt
    
    __mediadetailsall=$(mediainfo --output=JSON "$1$2");
    
    printf "$__mediadetailsall\n"  > "$FULLCACHEDIR""$2".json
    #echo $__mediadetails;
}

#////////////////////////////////
function __processeFile()
{
    
    CURRDIRECTORYNAME=$1
    CURRFULLFILENAME=$2
    CURRFILENAME=""
    CURRFileExtension=""
    
    __getMediaInfo  "$1" "$2"
    
    printf "$1$2----$CURRFILENAME\n"  >> "$FULLFILEDIR"$TOKEN-files.txt
    
    ((fileScannedCnt=fileScannedCnt+1))
    
}

#////////////////////////////////
function __processDir()
{
    local currentPath=$1 prefix="$2"
    
    tmparray=()
    
    ((dirScannedCnt=$dirScannedCnt+1))
    
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
            __processDir "$currentPath/${currentDir[$index]}" "$prefix""│ "
        else
            __processeFile "$currentPath/" "${currentDir[$index]}"
        fi
    done
    
    if [ $lastIndex -ge 0 ]; then
        printf "$prefix└─${currentDir[$lastIndex]}\n"
        #printf "%s└─%s\n" "$prefix" ${currentDir[$lastIndex]}
        if [ -d "$currentPath/${currentDir[$index]}" ]; then
            __processDir "$currentPath/${currentDir[$index]}" "$prefix""  "
        else
            #printf "$currentPath/${currentDir[$index]}\n"  >> $UNIQID-files.txt
            __processeFile "$currentPath/" "${currentDir[$index]}"
        fi
    fi
}

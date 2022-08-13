#!/bin/bash
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

# emojipedia.org

#set -e    # this line will stop the script on error
#set -xv   # this line will enable debug

#Scan a directory recurisivly and report on contents

# ./scanfiles.sh /mnt/share/allmovies/backup-3/X 0000 [Red]
# ./scanfiles.sh /mnt/share/movies/2021-01-January-1/ 0000 [Red]
# sudo ./scanfiles.sh /mnt/share/backup-3/Movies12 0000 [Red]

# sudo mount.cifs //192.168.1.130/backup-3 /mnt/share/backup-3/ -o user=xxx,pass=xxx
# sudo mount.cifs //192.168.1.134/bbc-recordings /mnt/share/bbc/ -o user=eva,pass=xxxx

# ./scanfiles.sh "/mnt/share/bbc/__2022 April" april


. $(dirname $0)/bin/_vars.sh
. $(dirname $0)/bin/_logging.sh
. $(dirname $0)/bin/_common.sh


items="album: .media.track[0].Album"
items+=", title: .media.track[0].Title"
items+=", grouping: .media.track[0].Grouping"
items+=", genre: .media.track[0].Genre"
items+=", contenttype: .media.track[0].ContentType"
items+=", description: .media.track[0].Description"
items+=", recorded_date: .media.track[0].Recorded_Date"
items+=", lyrics: .media.track[0].Lyrics"
items+=", comment: .media.track[0].Comment"
items+=", longdescription: .media.track[0].extra.LongDescription"
items+=", duration: .media.track[0].Duration"
items+=", filesize:.media.track[0].FileSize"
items+=", format:.media.track[0].Format"
items+=", fileextension:.media.track[0].FileExtension"

UNIQID=$2

logDir="./log/"
fileDir="./files/"

# Check log directory
if [ -d "${LOGDIR}" ] ; then
    _writeLog "✔️     $LOGDIR directory exists";
else
    _writeLog "✔️     $LOGDIR does exist, creating";
    mkdir $LOGDIR
fi

# Check fle directory
if [ -d "${FILEDIR}" ] ; then
    _writeLog "✔️     $FILEDIR directory exists";
else
    _writeLog "✔️     $FILEDIR does exist, creating";
    mkdir $FILEDIR
fi

#////////////////////////////////
function _writeLog {
    
    echo "$1"
    echo $1 >> "$logDir"scanfiles-log-$UNIQID.txt
    
}

#////////////////////////////////
function _writeErrorLog {
    
    echo $1 >> "$logDir"scanfiles-error-$UNIQID.txt
    
}

#////////////////////////////////
_processedfile()
{
    printf "$1$2\n"  >> "$fileDir"$UNIQID-files.txt
    _getMediaInfo  "$1" "$2"
    ((fileScannedCnt=fileScannedCnt+1))
    
}

#////////////////////////////////
_getMediaInfo()
{
    __mediadetails=$(mediainfo --output=JSON "$1$2"  |  jq '. | {'"$items"'}');
    printf "$__mediadetails\n"  >> "$fileDir"$UNIQID-mediaDetails.txt
    #echo $__mediadetails;
}

#////////////////////////////////
_processdir()
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
            _processdir "$currentPath/${currentDir[$index]}" "$prefix""│ "
        else
            _processedfile "$currentPath/" "${currentDir[$index]}"
        fi
    done
    
    if [ $lastIndex -ge 0 ]; then
        printf "$prefix└─${currentDir[$lastIndex]}\n"
        #printf "%s└─%s\n" "$prefix" ${currentDir[$lastIndex]}
        if [ -d "$currentPath/${currentDir[$index]}" ]; then
            _processdir "$currentPath/${currentDir[$index]}" "$prefix""  "
        else
            #printf "$currentPath/${currentDir[$index]}\n"  >> $UNIQID-files.txt
            _processedfile "$currentPath/" "${currentDir[$index]}"
        fi
    fi
}

function usage() {
    set -e
    cat <<EOM

    ##### gitreport #####
    Script to generate various reports on with a manifest file which list multiple github repo projects
    or you can supply a single repo name

    One of the following is required:

    Required arguments:
        -d | --directory        The starting directory to use, defaults to current directory
        -t | --token            The token to use for file names

    Optional arguments:
        -k | --keep             Set to 1 to keep temp files directory, defaults to off (0)
        -d | --debug            Set to 1 to switch on, defaults to off (0)
        -o | --output           Where to output the log to, defaults to current directory

    Requirements:
        jq:                 Local jq installation
        mediainfo:          Local mediainfo installation

    Examples:
      Run a report

        ../bin/gitreport.sh -m mymanifest.txt -t xxxxxxxxxxxxxxxx -r branch

        ./scanfiles.sh "/mnt/share/bbc/__2022 April" april
    Notes:

EOM
    
    exit 2
}

# check for required software
__require jq
__require mediainfo

# Need to add validation for input here

if [ $# == 0 ]; then usage; fi

PASSED=$1

if [ -d "${PASSED}" ] ; then
    echo "✔️         $PASSED is a directory";
else
    if [ -f "${PASSED}" ]; then
        echo "❌         ${PASSED} is a file";
    else
        echo "❌         ${PASSED} is not valid";
        exit 1
    fi
fi

# Check files directory
if [ -d "${logDir}" ] ; then
    echo "✔️         $logDir directory exists";
else
    echo "✔️         $logDir does exist, creating";
    mkdir $logDir
fi

# Check log directory
if [ -d "${fileDir}" ] ; then
    echo "✔️         $fileDir directory exists";
else
    echo "✔️         $fileDir does exist, creating";
    mkdir $fileDir
fi

_writeLog "⏲️     Starting............"
_writeLog "⏲️     ========================================="

OS=$(__getOSType)

dirCnt=0
movCnt=0
existCnt=0
errCnt=0
cnt=0

_processdir "$PASSED"

_writeLog "😲     ========================================="
_writeLog "😲     Number of directories scanned $dirScannedCnt"
_writeLog "😲     Number of files scanned $fileScannedCnt"
_writeLog "😲     ========================================="

_writeLog "👋     Complete!!!"

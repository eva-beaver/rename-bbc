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

# ./scanfiles.sh -d /home/eva/bbc/ -t bbc
# sudo ./scanfiles.sh -d /home/eva/bbc/ -t bbc
# sudo ./scanfiles.sh -d /home/eva/bbc/ -t bbc -p 1

# sudo mount.cifs //192.168.1.130/backup-3 /mnt/share/backup-3/ -o user=xxx,pass=xxx
# sudo mount.cifs //192.168.1.134/bbc-recordings /mnt/share/bbc/ -o user=eva,pass=xxxx



. $(dirname $0)/bin/_vars.sh
. $(dirname $0)/bin/_logging.sh
. $(dirname $0)/bin/_common.sh
. $(dirname $0)/bin/_postgresdb.sh
. $(dirname $0)/bin/_file_processing.sh

SCRIPT_NAME="scanfiles"

function usage() {
    set -e
    cat <<EOM

    ##### gitreport #####
    Script to generate various reports on with a manifest file which list multiple github repo projects
    or you can supply a single repo name

    One of the following is required:

    Required arguments:
        -d | --directory        The starting directory to use, defaults to current directory
        -t | --token            The token to use for unique file names

    Optional arguments:
        -p | --persist          Set to 1 to persist file data to the postgres database, defaults to no (0)
        -k | --keep             Set to 1 to keep temp files directory, defaults to off (0)
        -d | --debug            Set to 1 to switch on, defaults to off (0)
        -o | --output           Where to output the log to, defaults to current directory

    Requirements:
        jq:                 Local jq installation
        mediainfo:          Local mediainfo installation
        psql:               Local postgres command line tool

    Examples:
      Run a report

        ./scanfiles.sh "/mnt/share/bbc/__2022 April" april

        ./scanfiles.sh -d /home/eva/bbc/ -t bbc -p 1

    Notes:

EOM
    
    exit 2
}

# check for required software
__require jq
__require mediainfo
__require psql

# validation input here

if [ $# == 0 ]; then usage; fi

OUTPUT=$(pwd)

_DIRECTORY=""
_TOKEN=""
_PERSISTDATA=0
_KEEPFILES=1
_KEEPCACHE=1
_DEBUG=0

# Loop through arguments, two at a time for key and value
while [[ $# > 0 ]]
do
    key="$1"
    
    case ${key} in
        -d|--directory)
            _DIRECTORY="$2"
            shift # past argument
        ;;
        -t|--token)
            _TOKEN="$2"
            shift # past argument
        ;;
        -p|--persist)
            _PERSISTDATA="$2"
            shift # past argument
        ;;
        -d|--debug)
            _DEBUG=1
            shift # past argument
        ;;
        -k|--keepFiles)
            _KEEPFILES=1
            shift # past argument
        ;;
        -k|--keepCache)
            _KEEPCACHE=1
            shift # past argument
        ;;
        -o|--output)
            _OUTPUT="$2"
            shift # past argument
        ;;
        *)
            usage
            exit 2
        ;;
    esac
    shift # past argument or value
done

DIRECTORY_NAME=$_DIRECTORY
TOKEN=$_TOKEN
PERSISTDATA=$_PERSISTDATA
KEEPFILES=$_KEEPFILES
KEEPCACHE=$_KEEPCACHE
DEBUG=$_DEBUG

_checkLogDir

FULLFILEDIR="$SCRIPT_DIR_PARENT/$FILEDIR/"
FULLCACHEDIR="$SCRIPT_DIR_PARENT/$CACHEDIR/"

# Check file directory
if [ -d "${FULLFILEDIR}" ] ; then
    _writeLog "✔️     File directory exists ($FULLFILEDIR)";
else
    _writeLog "✔️     File does exist, creating ($FULLFILEDIR)";
    mkdir $FULLFILEDIR
fi

# Check cache directory
if [ -d "${FULLCACHEDIR}" ] ; then
    _writeLog "✔️     Cache directory exists ($FULLCACHEDIR)";
else
    _writeLog "✔️     Cache does exist, creating ($FULLCACHEDIR)";
    mkdir $FULLCACHEDIR
fi

if [[ $DIRECTORY_NAME = "missing" ]]
then
    _writeErrorLog "❌        No directory provided";
    exit 2
fi

if [ -d "${DIRECTORY_NAME}" ] ; then
    _writeLog "✔️     $DIRECTORY_NAME is a directory";
else
    if [ -f "${DIRECTORY_NAME}" ]; then
        _writeErrorLog "❌     ${DIRECTORY_NAME} is a file";
    else
        _writeErrorLog "❌     ${DIRECTORY_NAME} is not valid";
        exit 1
    fi
fi

_writeLog "⏲️     Starting............"
_writeLog "⏲️     ========================================="

if [[ $KEEPFILES -ne 1 ]]; then
    _writeLog "✔️        Files will be removed Removed ${FULLFILEDIR}"
fi

OS=$(__getOSType)

dirScannedCnt=0
fileScannedCnt=0

export PGPASSWORD='changeme';

if [[ $PERSISTDATA -eq 1 ]]; then
    rslt=$(_checkPostgresStatus)
    if [[ $rslt -eq 0 ]]; then
        _writeLog "✔️     Postgres db [$DBServer] ping response success!!!"
    else
        _writeErrorLog "❌    Postgres db [$DBServer] ping failed"
        exit 1
    fi
fi

# call main funtion to do the processing
__processDir "$DIRECTORY_NAME"

_writeLog "😲     ========================================="
_writeLog "😲     Number of directories scanned $dirScannedCnt"
_writeLog "😲     Number of files scanned $fileScannedCnt"
_writeLog "😲     ========================================="

if [[ $KEEPFILES -ne 1 ]]; then
    #rm -rf ${FULLFILEDIR}
    _writeLog "✔️        Removed ${FULLFILEDIR}"
fi

if [[ $KEEPCACHE -ne 1 ]]; then
    #rm -rf ${FULLCACHEDIR}
    _writeLog "✔️        Removed ${FULLCACHEDIR}"
fi

_writeLog "👋     Complete!!!"

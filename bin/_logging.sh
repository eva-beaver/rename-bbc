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

# usage: print [args...]
function print() {
    echo "${CURRENT_SCRIPT}: $*"
}

# usage: print_raw [args...]
function print_raw() {
    echo "$*"
}

# usage: error [args...]
function error() {
    print "error: $*" >&2
}

# usage: error_raw [args...]
function error_raw() {
    print_raw "$*" >&2
}

#////////////////////////////////
function _checkLogDir {
    
    FULLLOGDIR="$SCRIPT_DIR_PARENT/$LOGDIR/"
    
    # Check log directory
    if [ -d "${FULLLOGDIR}" ] ; then
        _writeLog "✔️     $FULLLOGDIR directory exists";
    else
        mkdir $FULLLOGDIR
        _writeLog "✔️     $FULLLOGDIR does exist, creating";
    fi
    
}

#////////////////////////////////
function _writeLog {
    
    #echo "$1"
    #echo $1 >> $SCRIPT_DIR_PARENT/$LOGDIR/$SCRIPT_NAME-log-$UNIQID.txt
    
    printf "$1\n"
    printf "$1\n" >> $SCRIPT_DIR_PARENT/$LOGDIR/$SCRIPT_NAME-log-$UNIQID.txt
    
}

#////////////////////////////////
function _writeLogNNL {
    
    #echo "$1"
    #echo $1 >> $SCRIPT_DIR_PARENT/$LOGDIR/$SCRIPT_NAME-log-$UNIQID.txt
    
    printf "$1"
    printf "$1" >> $SCRIPT_DIR_PARENT/$LOGDIR/$SCRIPT_NAME-log-$UNIQID.txt
    
}

#////////////////////////////////
function _writeErrorLog {
    
    #echo "$1"
    #echo $1 >> $SCRIPT_DIR_PARENT/$LOGDIR/$SCRIPT_NAME-log-$UNIQID.txt
    #echo $1 >> $SCRIPT_DIR_PARENT/$LOGDIR/$SCRIPT_NAME-errors-$UNIQID.txt
    
    printf "$1\n"
    printf "$1\n" >> $SCRIPT_DIR_PARENT/$LOGDIR/$SCRIPT_NAME-log-$UNIQID.txt
    printf "$1\n" >> $SCRIPT_DIR_PARENT/$LOGDIR/$SCRIPT_NAME-errors-$UNIQID.txt
    
}

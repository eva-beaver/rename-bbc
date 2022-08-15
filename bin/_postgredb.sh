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

DBServer="127.0.0.1"
DBUser="postgres"
DatabaseName="test"

Datatable="create table data"
Datatable=+"("
Datatable=+"   uuidkey          uuid         not null ,"
Datatable=+"   directorypath    varchar(256) not null ,"
Datatable=+"   directoryname    varchar(256) not null ,"
Datatable=+"   filename         varchar(256) not null ,"
Datatable=+"   extension        varchar(10)  not null ,"
Datatable=+"   mediainfo        jsonb        not null default '{}'::jsonb"
Datatable=+");"


#////////////////////////////////
function _checkPostgresStatus {
    
    if ($( ping $DBServer -c1 > /dev/null )) ; then
        echo "Postgres db ping response succsess!!!"
    fi
    
}

#////////////////////////////////
function _checkIfDatabaseExists {
    
    if [ "$( psql -h $DBServer -U $DBUser -XtAc "SELECT 1 FROM pg_database WHERE datname='$DatabaseName'" )" = '1' ]
    then
        echo "Database already exists"
    else
        echo "Database does not exist"
    fi
    
}

#////////////////////////////////
function _createDatabase {
    
    psql -h $DBServer -U $DBUser -XtAc "create database $DatabaseName" > ./log/result.txt 2>&1
    if [ $? -ne 0 ]; then
        echo "Database creation failed [$DatabaseName]"
        rslt=$(<./log/result.txt)
        echo $rslt
        rm -f ./log/result.txt
    else
        rm -f ./log/result.txt
    fi
    #$SCRIPT_DIR_PARENT/$LOGDIR/
}

#////////////////////////////////
function _runSQL {
    
    psql -h $DBServer -U $DBUser -d $DatabaseName -XtAc "$1" > ./log/result.txt 2>&1
    if [ $? -ne 0 ]; then
        echo "Database command failed [$1]"
        rslt=$(<./log/result.txt)
        echo $rslt
        rm -f ./log/result.txt
    else
        rm -f ./log/result.txt
    fi
    #$SCRIPT_DIR_PARENT/$LOGDIR/
}

#////////////////////////////////
# Insert data into postgres database
# usage
#   $1 = full directory path
#   $2 = directory name
#   $3 = filename
#   $4 = file type
#   $5 = media data
function _insertData {
    
    psql -h $DBServer -U $DBUser -d $DatabaseName -c "INSERT INTO data VALUES (uuid_generate_v4(), '$1', '$2', '$3', '$CURRFileExtension', '$__mediadetailsallfix');" > ./log/result.txt 2>&1
    if [ $? -ne 0 ]; then
        echo "Database insert failed"
        rslt=$(<./log/result.txt)
        echo $rslt
        rm -f ./log/result.txt
    else
        rm -f ./log/result.txt
    fi
    
}

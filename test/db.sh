#!/usr/bin/env bash


DBServer="127.0.0.1"
DBUser="postgres"
DatabaseName="testx"


export PGPASSWORD='changeme';


if ($( ping $DBServer -c1 > /dev/null )) ; then
    echo "db ping response succsess!!!"
fi


if [ "$(psql -h $DBServer -U $DBUser -XtAc "SELECT 1 FROM pg_database WHERE datname='$DatabaseName'" )" = '1' ]
then
    echo "Database already exists"
else
    echo "Database does not exist"
fi

#psql -h $DBServer -U $DBUser -c "create database $DatabaseName"

#exit 1

psql -h $DBServer -U $DBUser -XtAc "create database $DatabaseName" > ../log/result.txt 2>&1
if [ $? -ne 0 ]; then
    echo "Database creation failed"
    rslt=$(<../log/result.txt)
    echo $rslt
    rm -f ../log/result.txt
else
    rm -f ../log/result.txt
fi

exit 1

rslt="$(psql -h $DBServer -U $DBUser -XtAc "create database $DatabaseName" )"

echo $rslt

exit 1

if [ "$(psql -h $DBServer -U $DBUser -c "create database $DatabaseName" )" = '1' ]
then
    echo "Database already exists"
else
    echo "Database created"
fi


#! /bin/bash

echo "Usage: $0 db_host db_name db_user"
echo "You can set PGPASSWORD env var to pass password to the script"

db_host=$1
db_port=$2
db_name=$3
db_user=$4

psql -U $db_user -d $db_name -h $db_host -p $db_port -c 'CREATE SCHEMA IF NOT EXISTS lab4'

for file in $(ls ./insert_sql/*.sql)
  do
  psql -U $db_user -d $db_name -h $db_host -f $file
done

#! /bin/bash

insert_sql_dir="./insert_sql"
mkdir $insert_sql_dir
for file in $(ls ./shapefiles/*.shp)
do
  filename=${file#*les/}
  filename=${filename%*.shp}
  shp2pgsql -s 2964 "./shapefiles/$filename" "lab4.$filename" > "$insert_sql_dir/insert_$filename.sql"
done


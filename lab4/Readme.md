## DB Set up for exercises was done using .sh scripts:
- `./generate_insert_sql.sh` - generates sql from shapefiles and puts them in insert_sql dir
- `./init.sh db_host db_port db_name db_user` - executes sql queries against database - you can passwors with PGPASSWORD env var

Shapefiles used for exercises are part of zip archive that can be downloaded from: https://qgis.org/downloads/data/qgis_sample_data.zip they can be foun in shpefiles directory

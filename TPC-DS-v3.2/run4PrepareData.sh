#!/bin/bash

root_path="$(pwd)"
data_path="${root_path}/data"
psql_data_path="${root_path}/data/pgsql/"
duckdb_data_path="${root_path}/data/duckdb"
mkdir -p ${duckdb_data_path}

stats_path="${data_path}/stats_simplified"
imdb_path="${data_path}/imdb"
tpcds_path="${root_path}/config/TPC-DS-v3.2"
tpcds_data="${root_path}/data/tpcds"
ce_path="${data_path}/ce"

./initpgSQL.sh
sleep 5

## PostgreSQL
# psql -U postgres -c "DROP DATABASE IF EXISTS stats;"
# psql -U postgres -c "CREATE DATABASE stats;"
# psql -U postgres -d stats -c "\i ${stats_path}/stats.sql;"

# cd ${stats_path}
# for i in `ls *.csv`; do
#   table=${i/.csv/}
#   echo "Loading $table..."
#   psql -U postgres -d stats -c  "\copy ${table} from '${stats_path}/${i}' with CSV header;"  
# done
# psql -U postgres  -d stats -c "\i ${stats_path}/stats_index.sql;"

## IMDB Database Script:
# psql -U postgres -c "DROP DATABASE IF EXISTS imdb;"
# psql -U postgres -c "CREATE DATABASE imdb;"
# psql -U postgres -d imdb -c "\i ${imdb_path}/schematext.sql;"

# cd ${imdb_path}

# for i in `ls *.csv`; do
#   table=${i/.csv/}
#   echo "Loading $table..."
#   psql -U postgres -d imdb -c  "\copy ${table} from '${imdb_path}/${i}' QUOTE '\"' ESCAPE '\' csv;"  
# done

# psql -U postgres  -d imdb -c "\i ${root_path}/workload/imdb/fkindexes.sql;"


## TPC-DS Data
tpcds_workload="${root_path}/workload/tpcds/queries"
scale=1

rm -rf ${tpcds_data} 
rm -rf ${tpcds_workload}
mkdir ${tpcds_data}
mkdir ${tpcds_workload}

cd "${tpcds_path}/tools"
make clean
make -f Makefile.suite

./dsdgen -scale ${scale} -force -DIR ${tpcds_data}

for q in {1..99}; do		
	./dsqgen -DIRECTORY "${tpcds_path}/query_templates" -template "query${q}.tpl" -VERBOSE Y -QUALIFY Y -SCALE ${scale} -DIALECT netezza -OUTPUT_DIR "${tpcds_workload}"
  mv "${tpcds_workload}/query_0.sql" "${tpcds_workload}/${q}.sql" 
done

psql -U postgres -c "DROP DATABASE IF EXISTS tpcds;"
psql -U postgres -c "CREATE DATABASE tpcds ENCODING 'UTF8';"
psql -U postgres -d tpcds -c "\i ${root_path}/config/TPC-DS-v3.2/tools/tpcds.sql;"

cd ${tpcds_data}
for i in `ls *.dat`; do
  table=${i/.dat/}
  echo "Loading $table..."
  tmp_tbl="${tpcds_data}/${table}.tmp"
  sed 's/|$//' $i > ${tmp_tbl}

  if [[ "$i" == "customer.dat" ]]; then
    python3 ${tpcds_path}/fix_encoding.py --filename="${tmp_tbl}"
  fi

  psql -U postgres -d tpcds -c  "\copy ${table} from ${tmp_tbl} CSV DELIMITER '|'"
  rm -rf ${tmp_tbl}
done

## CE dataset
# cd ${ce_path}
# psql -U postgres -c "DROP DATABASE IF EXISTS ce;"
# psql -U postgres -c "CREATE DATABASE ce;"
# psql -U postgres -d ce -c "\i schema.sql;"
# psql -U postgres -d ce -c "\i load.sql;"


## DuckDB
# duckdb_exe="${root_path}/setup/Baselines/duckdb/"
# stats_duckdb_fname="${duckdb_data_path}/stats.duckdb"
# imdb_duckdb_fname="${duckdb_data_path}/imdb.duckdb"
# tpcds_duckdb_fname="${duckdb_data_path}/tpcds.duckdb"

# rm -rf ${stats_duckdb_fname}  # clean-up stats data
# rm -rf ${imdb_duckdb_fname}   # clean-up imdb data
# rm -rf ${tpcds_duckdb_fname}  # clean-up tpcds data

 
# cp "${stats_path}/stats-duckdb.sql" $duckdb_exe # prepare Stats database scripts

# cp "${imdb_path}/schematext.sql" "${duckdb_exe}/imdb-duckdb.sql" # prepare IMDB database schema script
# cat "${root_path}/workload/imdb/fkindexes.sql" >>  "${duckdb_exe}/imdb-duckdb.sql" # add IMDB index to scripts
# cd ${imdb_path}

# for i in `ls *.csv`; do
#   table=${i/.csv/}  
#   echo  "COPY ${table} from '${imdb_path}/${i}' (DELIMITER ',', QUOTE '\"', ESCAPE '\');" >>"${duckdb_exe}/imdb-duckdb.sql"  
# done

# cp "${root_path}/config/TPC-DS-v3.2/tools/tpcds.sql" "${duckdb_exe}/tpcds-duckdb.sql" # prepare TPC-DS database scripts
# cd ${tpcds_data}
# for i in `ls *.dat`; do
#   table=${i/.dat/}
#   echo "Loading $table..."
#   tmp_tbl="${tpcds_data}/${table}.tmp"
#   sed 's/|$//' $i > ${tmp_tbl}

#   if [[ "$i" == "customer.dat" ]]; then
#     python3 ${tpcds_path}/fix_encoding.py --filename="${tmp_tbl}"
#   fi

#   echo "COPY  ${table} FROM '${tmp_tbl}' (DELIMITER '|');" >> "${duckdb_exe}/tpcds-duckdb.sql" 
# done

# cd $duckdb_exe
# ./duckdb ${stats_duckdb_fname} .databases -init stats-duckdb.sql 
# ./duckdb ${imdb_duckdb_fname} .databases -init imdb-duckdb.sql 
# ./duckdb ${tpcds_duckdb_fname} .databases -init tpcds-duckdb.sql 

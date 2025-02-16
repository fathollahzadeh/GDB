#!/bin/bash

scale=$1
data_path=$2

root_path="$(pwd)"

export DSS_PATH=$data_path

rm -rf ${data_path} 
mkdir -p ${data_path}

echo $root_path

./dbgen -v -s ${scale}

cd ${data_path}
for i in `ls *.tbl`; do
  table=${i/.tbl/}
  #echo "Loading $table..."
  tmp_tbl="${data_path}/${table}.tmp"
  sed 's/|$//' $i > ${tmp_tbl}

  rm -rf "${data_path}/${table}.tbl"
  mv "${data_path}/${table}.tmp" "${data_path}/${table}.tbl"
done


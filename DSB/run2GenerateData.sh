#!/bin/bash

scale=$1
data_path=$2

root_path="$(pwd)"
echo $data_path

rm -rf ${data_path} 
mkdir -p ${data_path}

cd code/tools/
./dsdgen -scale ${scale} -force -DIR ${data_path}

cp -r tpcds.idx "${data_path}/" # save indexes
cp -r tpcds.sql "${data_path}/" # save database schema

cd ${data_path}
for i in `ls *.dat`; do
  table=${i/.dat/}
  #echo "Loading $table..."
  tmp_tbl="${data_path}/${table}.tmp"
  sed 's/|$//' $i > ${tmp_tbl}

  # if [[ "$i" == "customer.dat" ]]; then
  #   python3 ${root_path}/fix_encoding.py --filename="${tmp_tbl}"
  # fi

  rm -rf "${data_path}/${table}.dat"
  mv "${data_path}/${table}.tmp" "${data_path}/${table}.dat"
done
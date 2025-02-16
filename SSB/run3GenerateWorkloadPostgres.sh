#!/bin/bash

scale=$1
workload_path=$2

root_path="$(pwd)"

export DSS_CONFIG="${root_path}/dbgen"
export DSS_QUERY="$DSS_CONFIG/queries"

rm -rf ${workload_path}
mkdir -p ${workload_path}

cd dbgen/

for ((i=1;i<=22;i++)); do
  ./qgen -v -c -s $scale ${i} > "${workload_path}/query${i}.sql"
done
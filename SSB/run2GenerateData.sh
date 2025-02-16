#!/bin/bash

scale=$1
data_path=$2

root_path="$(pwd)"

export DSS_CONFIG="${root_path}/dbgen"
export DSS_QUERY="$DSS_CONFIG/queries"
export DSS_PATH=$data_path

rm -rf ${data_path} 
mkdir -p ${data_path}

echo $root_path

cd dbgen/
./dbgen -s ${scale}

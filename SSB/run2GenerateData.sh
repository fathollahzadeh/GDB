#!/bin/bash

scale=$1
data_path=$2

root_path="$(pwd)"

export DSS_PATH=$data_path

rm -rf ${data_path} 
mkdir -p ${data_path}

echo $root_path

./dbgen -v -s ${scale}


#!/bin/bash

scale=$1
data_path=$2
workload_path=$3

./run1Compile.sh
./run2GenerateData.sh $scale $data_path
./run3GenerateWorkloadPostgres.sh $scale $workload_path

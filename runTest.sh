#!/bin/bash

Test 1: generate TPC-DS v3.2 w/ scale=1 and streams=10 
cd TPC-DS-v3.2
scale=1
streams=10
root=/home/saeed/Downloads/tmp/TPC-DS-S${scale}-S${streams}
./runAll.sh $scale "${root}/data/" "${root}/workload/" $streams

# Test 2: generate TPC-DS v3.2 w/ scale=10 and streams=10 
# cd TPC-DS-v3.2
# scale=10
# streams=10
# root=/home/saeed/Downloads/tmp/TPC-DS-S${scale}-S${streams}
# ./runAll.sh $scale "${root}/data/" "${root}/workload/" $streams


# Test 3: generate TPC-H w/ scale=1 and streams=10 
# cd TPC-H
# scale=1
# root="/home/saeed/Downloads/tmp/TPC-H-S${scale}"
# ./runAll.sh ${scale} "${root}/data/" "${root}/workload/"

# Test 4: generate TPC-H w/ scale=1 and streams=10 
# cd TPC-H
# scale=10
# root="/home/saeed/Downloads/tmp/TPC-H-S${scale}"
# ./runAll.sh ${scale} "${root}/data/" "${root}/workload/"


# Test 3: setup PostgreSQL 17.1
# cd Install-Postgres-v17.1
# setup_path=/home/saeed/Downloads/tmp/Baseline/
# data_path=/home/saeed/Downloads/tmp/pgsqldata/
# ./setup.sh ${setup_path} ${data_path}

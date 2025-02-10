#!/bin/bash

## Test 1.1: generate TPC-DS v3.2 w/ scale=1 and streams=10 
cd TPC-DS-v3.2
scale=1
streams=1
root=/home/saeed/Downloads/tmp/TPC-DS-S${scale}-S${streams}
./runAll.sh $scale "${root}/data/" "${root}/workload/" $streams
cd ..

## Test 1.2: generate TPC-DS v3.2 w/ scale=10 and streams=10 
cd TPC-DS-v3.2
scale=10
streams=1
root=/home/saeed/Downloads/tmp/TPC-DS-S${scale}-S${streams}
./runAll.sh $scale "${root}/data/" "${root}/workload/" $streams
cd ..

## Test 1.3: generate TPC-DS v3.2 w/ scale=50 and streams=10 
cd TPC-DS-v3.2
scale=50
streams=1
root=/home/saeed/Downloads/tmp/TPC-DS-S${scale}-S${streams}
./runAll.sh $scale "${root}/data/" "${root}/workload/" $streams
cd ..

## Test 1.4: generate TPC-DS v3.2 w/ scale=50 and streams=10 
cd TPC-DS-v3.2
scale=100
streams=1
root=/home/saeed/Downloads/tmp/TPC-DS-S${scale}-S${streams}
./runAll.sh $scale "${root}/data/" "${root}/workload/" $streams
cd ..

#---------------------------------------------------------------
# Test 2.1: generate TPC-H w/ scale=1 
cd TPC-H
scale=1
root="/home/saeed/Downloads/tmp/TPC-H-S${scale}"
./runAll.sh ${scale} "${root}/data/" "${root}/workload/"
cd ..

# Test 2.2: generate TPC-H w/ scale=10 
cd TPC-H
scale=10
root="/home/saeed/Downloads/tmp/TPC-H-S${scale}"
./runAll.sh ${scale} "${root}/data/" "${root}/workload/"
cd ..

# Test 2.3: generate TPC-H w/ scale=50 
cd TPC-H
scale=50
root="/home/saeed/Downloads/tmp/TPC-H-S${scale}"
./runAll.sh ${scale} "${root}/data/" "${root}/workload/"
cd ..

# Test 2.3: generate TPC-H w/ scale=50 
cd TPC-H
scale=100
root="/home/saeed/Downloads/tmp/TPC-H-S${scale}"
./runAll.sh ${scale} "${root}/data/" "${root}/workload/"
cd ..

# Test 3: setup PostgreSQL 17.1
# cd Install-Postgres-v17.1
# setup_path=/home/saeed/Downloads/tmp/Baseline/
# data_path=/home/saeed/Downloads/tmp/pgsqldata/
# ./setup.sh ${setup_path} ${data_path}

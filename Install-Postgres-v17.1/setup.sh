#!/bin/bash

setup_path=$1
data_path=$2

mkdir -p ${setup_path}
mkdir -p ${data_path}

# Install postgreSQL benchmark
#-----------------------------
psql_bench_path="${setup_path}/PostgreSQL-v17.1"
psql_setup_path="${setup_path}/pgsql/17.1"
psql_data_path="${data_path}/pgsql"

rm -rf "${psql_bench_path}/pgsql" # clean-up
rm -rf ${psql_setup_path} # clean-up
rm -rf ${psql_data_path} # clean-up

mkdir ${psql_bench_path}

cp "postgresql_bench_builder.sh" ${psql_bench_path}

cd ${psql_bench_path}
./postgresql_bench_builder.sh

cd postgresql-17.1/
CMD="./configure --prefix=${psql_setup_path}"
$CMD  --enable-depend --enable-cassert --enable-debug CFLAGS="-ggdb -O0"
make && make install

var_1="export PATH=${psql_setup_path}/bin:\$PATH"
var_2="export LD_LIBRARY_PATH=${psql_setup_path}/lib/:\$LD_LIBRARY_PATH"

echo $var_1 >> ~/.bashrc
echo $var_2 >> ~/.bashrc
source ~/.bashrc

sudo groupadd -r postgres --gid=999 
sudo useradd -r -g postgres --uid=999 --home-dir=${psql_data_path} --shell=/bin/bash postgres
sudo chown -R postgres:postgres ${psql_data_path}
sudo touch "${psql_setup_path}/passwd"
sudo chmod -R 777 ${psql_setup_path}/passwd
sudo echo 'postgres' > "${psql_setup_path}/passwd"

${psql_setup_path}/bin/initdb -D ${psql_data_path} --username="postgres" --pwfile="${psql_setup_path}/passwd"

echo "host all all all md5" >> "${psql_data_path}/pg_hba.conf"
echo "listen_addresses = '*'" >> "${psql_data_path}/postgresql.conf"

#sed -i 's/max_wal_size = 1GB/max_wal_size = 100GB/g' "${psql_data_path}/postgresql.conf"
#sed -i 's/shared_buffers = 128MB/shared_buffers = 10GB/g' "${psql_data_path}/postgresql.conf"

#cpus="$(grep -c ^processor /proc/cpuinfo)"
echo "geqo = on" >> "${psql_data_path}/postgresql.conf"
#echo "max_parallel_workers = ${cpus}" >> "${psql_data_path}/postgresql.conf"
#echo "max_parallel_workers_per_gather = ${cpus}" >> "${psql_data_path}/postgresql.conf"
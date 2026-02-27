#!/bin/bash

set -x

#wget https://ftp.postgresql.org/pub/source/v13.1/postgresql-13.1.tar.bz2
#tar xvf postgresql-13.1.tar.bz2 && cd postgresql-13.1
#patch -s -p1 < ../postgresql_benchmark.patch

wget https://ftp.postgresql.org/pub/source/v17.1/postgresql-17.1.tar.bz2
tar xvf postgresql-17.1.tar.bz2 && cd postgresql-17.1

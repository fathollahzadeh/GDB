#!/bin/bash

cd dbgen/
if [ ! -f dbgen ]; then
  make clean
  make MACHINE=LINUX DATABASE=POSTGRESQL
fi

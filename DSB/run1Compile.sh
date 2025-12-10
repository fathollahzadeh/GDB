#!/bin/bash

cd code/tools/
if [ ! -f dsdgen ]; then
  make clean
  make
fi

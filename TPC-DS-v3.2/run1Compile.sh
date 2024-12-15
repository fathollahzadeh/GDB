#!/bin/bash

cd tools/
if [ ! -f dsdgen ]; then
  make clean
  make -f Makefile.suite
fi

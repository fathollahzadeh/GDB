#!/bin/bash

for rp in {1..99}; do
	fileName="query$rp.tpl"		
	echo $fileName
	#echo 'define _END = "";' >> $fileName
	sed -i 's/-- Contributors:/define _END = "";/' $fileName

done

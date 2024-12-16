#!/bin/bash

scale=$1
workload_path=$2
streams=$3

root_path="$(pwd)"
template_path="${root_path}/QueryTemplatesPostgres"

rm -rf ${workload_path}
mkdir -p ${workload_path}

cd tools/

for qt in agg_queries multi_block_queries spj_queries other_queries
 do
    for q in {1..102}; do
      for ext in .tpl _spj.tpl
        do
          query_name="query$(printf '%3s' "$q" | tr ' ' 0)"
          query_fname="${template_path}/${qt}/${query_name}${ext}"
          if [ -f $query_fname ]; then
            wn="${ext/.tpl/""}"
            wn="${workload_path}/${query_name}${wn}"
            rm -rf $wn
            
            tmp_path="${workload_path}/tmp_${query_name}"
            mkdir ${tmp_path}

            ./dsqgen -DIRECTORY "${template_path}/${qt}" -template "${query_name}${ext}" -VERBOSE Y -QUALIFY Y -SCALE ${scale} -DIALECT postgres -OUTPUT_DIR "${tmp_path}" -streams "$streams"

            mv ${tmp_path} ${wn}
                     
          fi
        done
    done
done

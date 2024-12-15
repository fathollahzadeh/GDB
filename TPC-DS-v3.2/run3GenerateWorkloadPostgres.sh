#!/bin/bash

scale=$1
workload_path=$2

root_path="$(pwd)"
template_path="${root_path}/QueryTemplatesPostgres"

rm -rf ${workload_path}
mkdir -p ${workload_path}

cd tools/

# Agg Queries
# agg_queries multi_block_queries spj_queries other_queries
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

            ./dsqgen -DIRECTORY "${template_path}/${qt}" -template "${query_name}${ext}" -VERBOSE Y -QUALIFY Y -SCALE ${scale} -DIALECT postgres -OUTPUT_DIR "${tmp_path}" -streams 5 

            mv ${tmp_path} ${wn}
                     
          fi
        done
    done
done


# for q in {1..99}; do		
# 	./dsqgen -DIRECTORY "${tpcds_path}/query_templates" -template "query${q}.tpl" -VERBOSE Y -QUALIFY Y -SCALE ${scale} -DIALECT netezza -OUTPUT_DIR "${tpcds_workload}"
#   mv "${tpcds_workload}/query_0.sql" "${tpcds_workload}/${q}.sql" 
# done

#!/bin/bash
ulimit -n 1048576
echo 3 >/proc/sys/vm/drop_caches

#iostat启动
iostat -x 5 | tee ${4}/iostat-read-ValueSize_${3}_DataSet_${2}_Cache_${5}G.txt &

tart Emon
source /opt/intel/emon_nda_11.32_linux_013109108d9bbb1/sep_vars.sh
emon -stop
mkdir -p /home/rocksdb_wjy/emonresult
emon -collect-edp > /home/rocksdb_wjy/emonresult/write-Dataset_${2}G_Value_${3}_DisWal_${5}.dat &


declare -i cache=1024\*1024\*1024\*${5}
declare -i data=${2}\*1024\*1024\*1024\/${3}
numactl -C 0-31 ./db_bench --benchmarks="readrandom,stats,levelstats" \
--db=${1} \
--reads=${6} \
--num=${data} \
--value_size=${3} --key_size=16 --enable_pipelined_write=true \
--read_cache_size=${cache} \
--cache_size=${cache} \
--use_existing_db=1 \
--enable_write_thread_adaptive_yield=false \
--disable_auto_compactions=false \
--compression_type=snappy \
--max_background_jobs=16 \
--allow_concurrent_memtable_write=true \
--batch_size=1 \
--histogram=true \
--target_file_size_base=67108864 \
--use_direct_io_for_flush_and_compaction=true \
--use_direct_reads=true \
--statistics=true \
--threads=96 \
--block_size=1 \
--report_interval_seconds=5 \
--report_file=${4}/read-ValueSize_${3}_DataSet_${2}_Cache_${5}G.csv \
| tee ${4}/read-ValueSize_${3}_DataSet_${2}_Cache_${5}G.txt \

###Emon finish
emon -stop


#结束iostat进程
ps -ef | grep iostat | grep -v grep | awk '{print $2}' | xargs kill -9

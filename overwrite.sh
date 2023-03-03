#!/bin/bash
ulimit -n 1048576
echo 3 >/proc/sys/vm/drop_caches

#iostat启动
iostat -x 5 | tee ${4}/iostat-write-Dataset_${2}G_Value_${3}_DisWal_${5}.txt &

###Start Emon
source /opt/intel/emon_nda_11.32_linux_013109108d9bbb1/sep_vars.sh
emon -stop
mkdir -p /home/rocksdb_wjy/emonresult
emon -collect-edp > /home/rocksdb_wjy/emonresult/write-Dataset_${2}G_Value_${3}_DisWal_${5}.dat &

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
declare -i data=${2}\*1024\*1024\*1024\/${3}
taskset -c 0-31,64-95 ./db_bench --benchmarks="overwrite,stats,levelstats" \
--use_existing_db=1 \
--db=${1} \
--value_size=${3} --key_size=16 --enable_pipelined_write=true \
--disable_wal=${5} \
--writes=9000000 \
--threads=96 \
--enable_write_thread_adaptive_yield=false \
--disable_auto_compactions=false \
--compression_type=snappy \
--max_background_jobs=16 \
--allow_concurrent_memtable_write=true \
--batch_size=1 \
--use_direct_io_for_flush_and_compaction=true \
--use_direct_reads=true \
--target_file_size_base=67108864 \
--sync=true \
--perf_level=2 \
--statistics \
--report_interval_seconds=5 \
--report_file=${4}/write_Dataset_${2}G_Value_${3}_DisWal_${5}.csv \
| tee ${4}/write_Dataset_${2}G_Value_${3}_DisWal_${5}.txt \

###Emon finish
emon -stop

ps -ef | grep iostat | grep -v grep | awk '{print $2}' | xargs kill -9

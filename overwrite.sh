#!/bin/bash
ulimit -n 1048576
echo 3 >/proc/sys/vm/drop_caches
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
declare -i data=${2}\*1024\*1024\*1024\/${3}
numactl -C 0-31 ./db_bench --benchmarks="overwrite,stats,levelstats" \
--db=${1} \
--value_size=${3} --key_size=16 --enable_pipelined_write=true \
--disable_wal=${5} \
--writes=3000000 \
--threads=96 \
--enable_write_thread_adaptive_yield=false \
--disable_auto_compactions=false \
--compression_type=snappy \
--max_background_jobs=16 \
--allow_concurrent_memtable_write=true \
--batch_size=1 \
--use_direct_io_for_flush_and_compaction=true \
--target_file_size_base=67108864 \
--sync=false \
--report_interval_seconds=5 \
--report_file=${4}/Dataset_${2}G_Value_${3}_DisWal_${5}.csv \
| tee ${4}/Dataset_${2}G_Value_${3}_DisWal_${5}.txt \



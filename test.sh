#!/bin/bash

read -p "test_path:" test_path
read -p "report_path:" report_path

mkdir ${report_path}


# WAL state(true or false)
disable_wal="false"

			
data_path="/mnt/nvme3"
dataset=200
value=256
cp -r ${data_path}/${value}B/${dataset}G/* ${test_path}
echo "复制${data_path}/${value}B/${dataset}G到${test_path}"

sleep 10
	
echo "进行测试写${dataset}G-value${value}-Disable_Wal-${disable_wal}"


./overwrite.sh ${test_path} ${dataset} ${value} ${report_path} ${disable_wal}
		
echo "sync测试"

rm -rf ${test_path}

cp -r /mnt/nvme3/256B/200G/* ${test_path}
echo "sync"
./overwrite_sync_off.sh ${test_path} 200 256 ${report_path} "false"
rm -rf ${test_path}
sleep 5

echo "本次测试完成删除test目录"
rm -rf ${test_path}
sleep 10

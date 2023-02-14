#!/bin/bash

##data&&test path
read -p "test_path:" test_path

read -p "report_path:" report_path
mkdir ${report_path}

# WAL state(true or false)
disable_wal="false"

value_size=128

mkdir ${test_path}/${value_size}B

for dataset in {200,400,600}
do	
	
	mkdir ${test_path}
	echo "创建${dataset}G-${value_size}B数据集"
	./writedata.sh ${test_path} ${dataset} ${value_size}
	sleep 10
	
	echo "进行测试写${dataset}G-value${value}-Disable_Wal-${disable_wal}"

	./overwrite.sh ${test_path} ${dataset} ${value_size} ${report_path} ${disable_wal}	

	sleep 5

	echo "本次测试完成删除test目录"
	rm -rf ${test_path}
	sleep 10


done


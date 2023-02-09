#!/bin/bash

read -p "test_path:" test_path
read -p "report_path:" report_path

mkdir ${report_path}


# WAL state(true or false)
disable_wal="false"

for value in {256,512,1024,4096}
do	
	if [ ${value} -eq 256 ];
	then 
	data_path="/mnt/nvme3"
	 
	elif [ ${value} -eq 512 ];
	then
     	data_path="/mnt/nvme4"

	elif [ ${value} -eq 1024 ];
	then
     	data_path="/mnt/nvme0"	

	else
	data_path="/mnt/nvme5"
	fi

	for dataset in {200,400,600}
	do	
		echo "创建测试目录${test_path}"
		mkdir ${test_path}

		cp -r ${data_path}/${value}B/${dataset}G/* ${test_path}
		echo "复制${data_path}/${value}B/${dataset}G到${test_path}"

		sleep 10
	
		echo "进行测试写${dataset}G-value${value}-Disable_Wal-${disable_wal}"


		./overwrite.sh ${test_path} ${dataset} ${value} ${report_path} ${disable_wal}
		

		sleep 5

		echo "本次测试完成删除test目录"
		rm -rf ${test_path}
		sleep 10

	done
done

cp -r /mnt/nvme3/256B/200G/* ${test_path}
echo "测试wal关闭"
./overwrite.sh ${test_path} 200 256 ${report_path} "true"
rm -rf ${test_path}

cp -r /mnt/nvme0/1024B/200G/* ${test_path}
echo "测试wal关闭"
./overwrite.sh ${test_path} 200 1024 ${report_path} "true"
rm -rf ${test_path}

cp -r /mnt/nvme3/256B/200G/* ${test_path}
echo "测试wal关闭"
./overwrite_sync_off.sh ${test_path} 200 256 ${report_path} "false"
rm -rf ${test_path}

cp -r /mnt/nvme0/1024B/200G/* ${test_path}
echo "测试wal关闭"
./overwrite_sync_off.sh ${test_path} 200 1024 ${report_path} "false"
rm -rf ${test_path}

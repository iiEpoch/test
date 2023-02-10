#!/bin/bash

read -p "test_path:" test_path
read -p "report_path:" report_path

mkdir ${report_path}


#reads
reads=5000000


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
		
		for read_cache_size in {25,50,100}
		do

			echo "创建测试目录${test_path}"
			mkdir ${test_path}

			cp -r ${data_path}/${value}B/${dataset}G/* ${test_path}
			echo "复制${data_path}/${value}B/${dataset}G到${test_path}"

			sleep 10
	
			echo "进行测试读${dataset}G-value${value}-cache${read_cache_size}"
			./read.sh ${test_path} ${dataset} ${value} ${report_path} ${read_cache_size} ${reads}
			sleep 10


			echo "本次测试完成删除test目录"
			rm -rf ${test_path}
			sleep 10
		done
	done
done



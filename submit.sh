#!/bin/bash


echo "${@: -1}"
jarPath=${@: -1}
name=$(basename $jarPath)

echo $name

length=$(($#-1))
args=${@:1:$length}
if docker cp $jarPath submitnode:/$name; then
	submitCmd="/usr/local/hadoop/etc/hadoop/hadoop-env.sh;/usr/local/spark/bin/spark-submit $args /$name"
	# submitCmd="/usr/local/spark/bin/spark-submit $args /$name"

	echo $submitCmd
	docker exec -it submitnode bash -c "export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/;/usr/local/spark/bin/spark-submit $args /$name"
else
	echo "Abort"
fi
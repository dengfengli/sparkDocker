#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

echo "Initilization...."

source $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
 
echo "Hadoop-config:"$HADOOP_CONF_DIR

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

service ssh start

if [[ $1 = "-namenode" || $2 = "-namenode" ]]; then
  $HADOOP_PREFIX/bin/hdfs namenode -force -nonInteractive -format hadoop-cluster-local
  $HADOOP_PREFIX/sbin/hadoop-daemon.sh --script hdfs start namenode
  $HADOOP_PREFIX/sbin/yarn-daemon.sh start resourcemanager
  $HADOOP_PREFIX/sbin/yarn-daemons.sh start nodemanager
  $HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver
  /usr/local/spark/sbin/start-history-server.sh
  # $HADOOP_PREFIX/sbin/start-dfs.sh
  # $HADOOP_PREFIX/sbin/start-yarn.sh
fi

if [[ `echo $1 | grep "datanode"` || `echo $2 | grep "datanode"` ]]; then
  # $HADOOP_PREFIX/sbin/start-dfs.sh
  echo "Prepare datanode"
  $HADOOP_PREFIX/sbin/hadoop-daemons.sh --script hdfs start datanode
  $HADOOP_PREFIX/sbin/yarn-daemons.sh start nodemanager
fi

if [[ $1 = "-d" || $2 = "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 = "-bash" || $2 = "-bash" ]]; then
  /bin/bash
fi
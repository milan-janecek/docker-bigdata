#!/bin/bash

echo "COPYING CONFIGURATION FILES FROM SHARE TO HADOOP CONF DIR"
cp -v /hadoop-share/conf/* $HADOOP_HOME/etc/hadoop

echo "SETTING HISTORY SERVER LOG DIRECTORY"
echo spark.history.fs.logDirectory hdfs:///spark/event-log >> $SPARK_HOME/conf/spark-defaults.conf

start-history-server.sh
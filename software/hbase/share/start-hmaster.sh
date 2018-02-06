#!/bin/bash

echo "COPYING CONFIGURATION FILES FROM SHARE TO CONF DIR"
cp -v /share/conf/* $HBASE_HOME/conf
cp -v /hadoop-share/conf/core-site.xml $HBASE_HOME/conf
cp -v /hadoop-share/conf/hdfs-site.xml $HBASE_HOME/conf

hbase master
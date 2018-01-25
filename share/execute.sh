#!/bin/bash
#
# Use this script to execute hadoop commands against the cluster.

echo "COPYING CONFIGURATION FILES FROM SHARE TO HADOOP CONF DIR"
cp -v /share/conf/* $HADOOP_HOME/etc/hadoop

echo "EXECUTING COMMAND"
exec $1 ${@:2}
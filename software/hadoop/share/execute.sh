#!/bin/bash
cp /share/conf/* $HADOOP_HOME/etc/hadoop
exec $1 ${@:2}
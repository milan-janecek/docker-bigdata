#!/bin/bash

echo "COPYING CONFIGURATION FILES FROM SHARE TO HADOOP CONF DIR"
cp -v /share/conf/* $HADOOP_HOME/etc/hadoop

yarn timelineserver
#!/bin/bash

ls -1 /tmp/hadoop-jars | while read hadoop_jar; do
  filepattern=$(echo $hadoop_jar | sed 's/[0-9]/[0-9]/g')
  find /usr/local -regex "/usr/local/hbase.*$filepattern" | while read hbase_file; do
    rm -rf $hbase_file
    cp -v /tmp/hadoop-jars/$hadoop_jar $(dirname $hbase_file)
  done
done
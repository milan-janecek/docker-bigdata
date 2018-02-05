#!/bin/bash

if [ $# -ne 2 ]; then
  echo "ERROR: Exactly 2 arguments are needed: hbase_home, hadoop_home."
  exit 1
fi

hbase_home=$1
hadoop_home=$2

echo "*** SCRIPT ARGUMENTS ***"
echo "hbase_home: $1"
echo "hadoop_home: $2"

echo "*** REPLACING HADOOP JARS ***"

find $hbase_home -name "hadoop-*.jar" | while read hbase_file; do
  filepattern=$(echo $(basename $hbase_file) | sed 's/[0-9].[0-9].[0-9]/[0-9].[0-9].[0-9]/')
  find $hadoop_home -regex "$hadoop_home/.*$filepattern" | while read hadoop_file; do
    echo "Replacing $hbase_file with $hadoop_file"
    rm -rf $hbase_file
    cp $hadoop_file $(dirname $hbase_file)
  done
done
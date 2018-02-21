#!/bin/bash

base_dir=$(dirname $0)

echo "Removing input/output folders from previous run"
hadoop fs -rm -r /user/vagrant/examples/mapreduce/wordcount/input
hadoop fs -rm -r /user/vagrant/examples/mapreduce/wordcount/output

echo "Creating input folder with input files"
hadoop fs -mkdir -p /user/vagrant/examples/mapreduce/wordcount/input
echo "Hello World Bye World" > $base_dir/wordcount/target/file01
echo "Hello Hadoop Goodbye Hadoop" > $base_dir/wordcount/target/file02
hadoop fs -copyFromLocal \
  $base_dir/wordcount/target/file01 \
  /user/vagrant/examples/mapreduce/wordcount/input/file01
hadoop fs -copyFromLocal \
  $base_dir/wordcount/target/file02 \
  /user/vagrant/examples/mapreduce/wordcount/input/file02

echo "Submitting job"
hadoop jar $base_dir/wordcount/target/wordcount-1.0.jar WordCount \
  /user/vagrant/examples/mapreduce/wordcount/input \
  /user/vagrant/examples/mapreduce/wordcount/output


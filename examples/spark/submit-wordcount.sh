#!/bin/bash

base_dir=$(dirname $0)

echo "Removing input/output folders from previous run"
hadoop fs -rm -r /user/vagrant/examples/spark/wordcount/input
hadoop fs -rm -r /user/vagrant/examples/spark/wordcount/output

echo "Creating input folder with input files"
hadoop fs -mkdir -p /user/vagrant/examples/spark/wordcount/input
echo "Hello World Bye World" > $base_dir/wordcount/target/file01
echo "Hello Hadoop Goodbye Hadoop" > $base_dir/wordcount/target/file02
hadoop fs -copyFromLocal \
  $base_dir/wordcount/target/file01 \
  /user/vagrant/examples/spark/wordcount/input/file01
hadoop fs -copyFromLocal \
  $base_dir/wordcount/target/file02 \
  /user/vagrant/examples/spark/wordcount/input/file02

echo "Submitting job"
spark-submit \
  --class SparkWordCount \
  --master yarn \
  --deploy-mode cluster \
  $base_dir/wordcount/target/scala-2.11/sparkwordcount_2.11-1.0.jar \
  /user/vagrant/examples/spark/wordcount/input \
  /user/vagrant/examples/spark/wordcount/output
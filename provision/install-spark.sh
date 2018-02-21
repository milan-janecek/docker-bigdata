#!/bin/bash

BASE_DIR=${BASE_DIR:-$(dirname $0)/..}
source $BASE_DIR/cluster/scripts/functions.sh

if [ $# -ne 3 ]; then
  echo "ERROR: Exactly 3 arguments are needed: mirror, version, sha512_checksum."
  exit 1
fi

mirror=$1
ver=$2
sha512_checksum=$3

echo "*** SCRIPT ARGUMENTS ***"
echo "mirror: $1"
echo "version: $2"
echo "sha512_checksum: $3"

echo "*** INSTALLING SPARK $ver ***"
if [ ! -d /usr/local/spark-$ver ]; then
  if [ ! -f $BASE_DIR/software/spark/spark-$ver-bin-without-hadoop.tgz ]; then
    echo "DOWNLOADING SPARK" 
    sudo curl -o $BASE_DIR/software/spark/spark-$ver-bin-without-hadoop.tgz \
      $mirror/spark-$ver/spark-$ver-bin-without-hadoop.tgz
  
    echo "VALIDATING CHECKSUM"
    echo "$sha512_checksum $BASE_DIR/software/spark/spark-$ver-bin-without-hadoop.tgz" | sha512sum -c -
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
      rm -rf $BASE_DIR/software/spark/spark-$ver-bin-without-hadoop.tgz
      echo "CHECKSUM VALIDATION FAILED - SPARK $ver HAS NOT BEEN INSTALLED"
      exit $exit_status
    else
      echo "CHECKSUM IS OK"
    fi
  fi
  
  echo "EXTRACTING SPARK ARCHIVE"
  sudo tar -zxf $BASE_DIR/software/spark/spark-$ver-bin-without-hadoop.tgz -C /usr/local
  sudo mv /usr/local/spark-$ver* /usr/local/spark-$ver

  sparkEnvFile="/usr/local/spark-$ver/conf/spark-env.sh"

  echo "ADDING HADOOP TO SPARK"
  addLineToFile 'export SPARK_DIST_CLASSPATH=$(hadoop classpath)' $sparkEnvFile
  addLineToFile 'export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native' $sparkEnvFile
  
  echo "SETTING HADOOP/YARN CONFIGURATION DIRECTORIES"
  addLineToFile 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' $sparkEnvFile
  addLineToFile 'export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop' $sparkEnvFile
    
  echo "SETTING SPARK DEFAULTS"
  sparkDefaultsFile="/usr/local/spark-$ver/conf/spark-defaults.conf"
  addLineToFile "spark.yarn.jars hdfs:///spark/jars/*" $sparkDefaultsFile
  addLineToFile "spark.eventLog.enabled true" $sparkDefaultsFile
  addLineToFile "spark.eventLog.dir hdfs:///spark/event-log" $sparkDefaultsFile
  addLineToFile "spark.yarn.am.memory 512m" $sparkDefaultsFile
  addLineToFile "spark.driver.memory 512m" $sparkDefaultsFile
  addLineToFile "spark.executor.memory 512m" $sparkDefaultsFile
   
  echo "SPARK $ver HAS BEEN SUCCESSFULLY INSTALLED AND CONFIGURED"
else
  echo "SPARK $ver IS ALREADY INSTALLED"
fi

echo "*** CONFIGURING ENVIRONMENT TO USE SPARK $ver ***"
profileFile="/etc/profile.d/spark.sh"
sudo rm -rf $profileFile
addLineToFile "export SPARK_HOME=/usr/local/spark-$ver" $profileFile
addLineToFile 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' $profileFile
addLineToFile "export SPARK_VER=$ver" $profileFile
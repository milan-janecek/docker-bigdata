#!/bin/bash

BASE_DIR=${BASE_DIR:-$(dirname $0)/..}
source $BASE_DIR/cluster/scripts/functions.sh

if [ -f $BASE_DIR/provision/configs/config.sh ]; then
  source $BASE_DIR/provision/configs/config.sh
else
  source $BASE_DIR/provision/configs/default-config.sh
fi

APACHE_MIRROR=$APACHE_MIRROR/spark

echo "*** INSTALLING SPARK $SPARK_VER ***"
if [ ! -d /usr/local/spark-$SPARK_VER ]; then
  if [ ! -f $BASE_DIR/software/spark/spark-$SPARK_VER-bin-without-hadoop.tgz ]; then
    echo "DOWNLOADING SPARK" 
    sudo curl -o $BASE_DIR/software/spark/spark-$SPARK_VER-bin-without-hadoop.tgz \
      $APACHE_MIRROR/spark-$SPARK_VER/spark-$SPARK_VER-bin-without-hadoop.tgz
  
    echo "VALIDATING CHECKSUM"
    echo "$SPARK_SHA512_CHECKSUM $BASE_DIR/software/spark/spark-$SPARK_VER-bin-without-hadoop.tgz" | sha512sum -c -
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
      rm -rf $BASE_DIR/software/spark/spark-$SPARK_VER-bin-without-hadoop.tgz
      echo "CHECKSUM VALIDATION FAILED - SPARK $SPARK_VER HAS NOT BEEN INSTALLED"
      exit $exit_status
    else
      echo "CHECKSUM IS OK"
    fi
  fi
  
  echo "EXTRACTING SPARK ARCHIVE"
  sudo tar -zxf $BASE_DIR/software/spark/spark-$SPARK_VER-bin-without-hadoop.tgz -C /usr/local
  sudo mv /usr/local/spark-$SPARK_VER* /usr/local/spark-$SPARK_VER

  sparkEnvFile="/usr/local/spark-$SPARK_VER/conf/spark-env.sh"

  echo "ADDING HADOOP TO SPARK"
  addLineToFile 'export SPARK_DIST_CLASSPATH=$(hadoop classpath)' $sparkEnvFile
  addLineToFile 'export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native' $sparkEnvFile
  
  echo "SETTING HADOOP/YARN CONFIGURATION DIRECTORIES"
  addLineToFile 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' $sparkEnvFile
  addLineToFile 'export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop' $sparkEnvFile
    
  echo "SETTING SPARK DEFAULTS"
  sparkDefaultsFile="/usr/local/spark-$SPARK_VER/conf/spark-defaults.conf"
  addLineToFile "spark.yarn.jars hdfs:///spark/jars/*" $sparkDefaultsFile
  addLineToFile "spark.eventLog.enabled true" $sparkDefaultsFile
  addLineToFile "spark.eventLog.dir hdfs:///spark/event-log" $sparkDefaultsFile
  addLineToFile "spark.yarn.am.memory 512m" $sparkDefaultsFile
  addLineToFile "spark.driver.memory 512m" $sparkDefaultsFile
  addLineToFile "spark.executor.memory 512m" $sparkDefaultsFile
   
  echo "SPARK $SPARK_VER HAS BEEN SUCCESSFULLY INSTALLED AND CONFIGURED"
else
  echo "SPARK $SPARK_VER IS ALREADY INSTALLED"
fi

echo "*** CONFIGURING ENVIRONMENT TO USE SPARK $SPARK_VER ***"
addEnvVarExportToFile SPARK_HOME /usr/local/spark-$SPARK_VER /etc/profile
addLineToFile 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' /etc/profile
addEnvVarExportToFile SPARK_VER $SPARK_VER /etc/profile
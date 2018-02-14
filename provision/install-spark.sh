#!/bin/bash

if [ $# -ne 3 ]; then
  echo "ERROR: Exactly 3 arguments are needed: mirror, version, sha512_checksum."
  exit 1
fi

BASE_DIR=${BASE_DIR:-$(dirname $0)/..}

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

  sudo mv /usr/local/spark-$ver/conf/spark-env.sh.template /usr/local/spark-$ver/conf/spark-env.sh
  sudo mv /usr/local/spark-$ver/conf/spark-defaults.conf.template /usr/local/spark-$ver/conf/spark-defaults.conf
  
  echo "ADDING HADOOP TO SPARK"
  sudo sh -c \
    'echo export SPARK_DIST_CLASSPATH=\$\(hadoop classpath\) >> /usr/local/spark-2.2.1/conf/spark-env.sh'
  
  echo "SETTING HADOOP/YARN CONFIGURATION DIRECTORIES"
  sudo sh -c \
    'echo export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop >> /usr/local/spark-'$ver'/conf/spark-env.sh'
  sudo sh -c \
    'echo export YARN_CONF_DIR=\$HADOOP_HOME/etc/hadoop >> /usr/local/spark-'$ver'/conf/spark-env.sh'
    
  echo "SETTING SPARK DEFAULTS"
  sudo sh -c \
    'echo spark.yarn.jars hdfs:///spark/jars/* >> /usr/local/spark-'$ver'/conf/spark-defaults.conf'
  sudo sh -c \
    'echo spark.eventLog.enabled true >> /usr/local/spark-'$ver'/conf/spark-defaults.conf'
  sudo sh -c \
    'echo spark.eventLog.dir hdfs:///spark/event-log >> /usr/local/spark-'$ver'/conf/spark-defaults.conf'  
      
  echo "SPARK $ver HAS BEEN SUCCESSFULLY INSTALLED AND CONFIGURED"
else
  echo "SPARK $ver IS ALREADY INSTALLED"
fi

echo "*** CONFIGURING ENVIRONMENT TO USE SPARK $ver ***"
echo "SETTING SPARK_HOME"
sudo sh -c \
  "echo export SPARK_HOME=/usr/local/spark-$ver > /etc/profile.d/spark-home.sh"
  
echo "ADDING SPARK BIN TO PATH"
sudo sh -c \
  'echo export PATH=\$PATH:/usr/local/spark-'$ver'/bin > /etc/profile.d/spark-bin.sh'
  
echo "ADDING SPARK SBIN TO PATH"
sudo sh -c \
  'echo export PATH=\$PATH:/usr/local/spark-'$ver'/sbin > /etc/profile.d/spark-sbin.sh'
  
echo "SETTING SPARK_VER"
sudo sh -c \
  "echo export SPARK_VER=$ver > /etc/profile.d/spark-ver.sh"
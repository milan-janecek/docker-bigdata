#!/bin/bash

BASE_DIR=${BASE_DIR:-$(dirname $0)/..}
source $BASE_DIR/cluster/scripts/functions.sh

if [ -f $BASE_DIR/provision/configs/config.sh ]; then
  source $BASE_DIR/provision/configs/config.sh
else
  source $BASE_DIR/provision/configs/default-config.sh
fi

APACHE_MIRROR=$APACHE_MIRROR/hadoop/common

echo "*** INSTALLING HADOOP $HADOOP_VER ***"
if [ ! -d /usr/local/hadoop-$HADOOP_VER ]; then

  if [ ! -f $BASE_DIR/software/hadoop/hadoop-$HADOOP_VER.tar.gz ]; then
    echo "DOWNLOADING HADOOP" 
    sudo curl -o $BASE_DIR/software/hadoop/hadoop-$HADOOP_VER.tar.gz \
      $APACHE_MIRROR/hadoop-$HADOOP_VER/hadoop-$HADOOP_VER.tar.gz
  
    echo "VALIDATING CHECKSUM"
    echo "$HADOOP_SHA1_CHECKSUM $BASE_DIR/software/hadoop/hadoop-$HADOOP_VER.tar.gz" | sha1sum -c -
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
      rm -rf $BASE_DIR/software/hadoop/hadoop-$HADOOP_VER.tar.gz
      echo "CHECKSUM VALIDATION FAILED - HADOOP $HADOOP_VER HAS NOT BEEN INSTALLED"
      exit $exit_status
    else
      echo "CHECKSUM IS OK"
    fi
  fi
  
  echo "EXTRACTING HADOOP ARCHIVE"
  sudo tar -zxf $BASE_DIR/software/hadoop/hadoop-$HADOOP_VER.tar.gz -C /usr/local
    
  echo "HADOOP $HADOOP_VER HAS BEEN SUCCESSFULLY INSTALLED AND CONFIGURED"
else
  echo "HADOOP $HADOOP_VER IS ALREADY INSTALLED"
fi

echo "*** CONFIGURING ENVIRONMENT TO USE HADOOP $HADOOP_VER ***"
addEnvVarExportToFile HADOOP_HOME /usr/local/hadoop-$HADOOP_VER /etc/profile
addLineToFile 'export PATH=$PATH:$HADOOP_HOME/bin' /etc/profile
addEnvVarExportToFile HADOOP_VER $HADOOP_VER /etc/profile
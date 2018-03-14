#!/bin/bash

BASE_DIR=${BASE_DIR:-$(dirname $0)/..}
source $BASE_DIR/cluster/scripts/functions.sh

if [ -f $BASE_DIR/provision/configs/config.sh ]; then
  source $BASE_DIR/provision/configs/config.sh
else
  source $BASE_DIR/provision/configs/default-config.sh
fi

source /etc/profile

APACHE_MIRROR=$APACHE_MIRROR/hbase

echo "*** INSTALLING HBASE $HBASE_VER ***"
if [ ! -d /usr/local/hbase-$HBASE_VER ]; then

  if [ ! -f $BASE_DIR/software/hbase/hbase-$HBASE_VER-bin.tar.gz ]; then
    echo "DOWNLOADING HBASE" 
    sudo curl -o $BASE_DIR/software/hbase/hbase-$HBASE_VER-bin.tar.gz \
      $APACHE_MIRROR/$HBASE_VER/hbase-$HBASE_VER-bin.tar.gz
  
    echo "VALIDATING CHECKSUM"
    echo "$HBASE_SHA1_CHECKSUM $BASE_DIR/software/hbase/hbase-$HBASE_VER-bin.tar.gz" | sha1sum -c -
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
      rm -rf $BASE_DIR/software/hbase/hbase-$HBASE_VER-bin.tar.gz
      echo "CHECKSUM VALIDATION FAILED - HBASE $HBASE_VER HAS NOT BEEN INSTALLED"
      exit $exit_status
    else
      echo "CHECKSUM IS OK"
    fi
  fi
  
  echo "EXTRACTING HBASE ARCHIVE"
  sudo tar -zxf $BASE_DIR/software/hbase/hbase-$HBASE_VER-bin.tar.gz -C /usr/local
  
  echo "*** REPLACING HADOOP JARS FOR LOCAL INSTALL AND MOVING HADOOP JARS TO DOCKER CONTEXT FOLDER ***"
  hbase_home=/usr/local/hbase-$HBASE_VER
  hadoop2hbase=$BASE_DIR/software/hbase/hadoop/$HADOOP_VER
  mkdir -p $hadoop2hbase/jars
  find $hbase_home -name "hadoop-*.jar" | while read hbase_file; do
    filepattern=$(echo $(basename $hbase_file) | sed 's/[0-9].[0-9].[0-9]/[0-9].[0-9].[0-9]/')
    find $HADOOP_HOME -regex "$HADOOP_HOME/.*$filepattern" | while read hadoop_file; do
      sudo rm -rf $hbase_file
      sudo cp -v $hadoop_file $(dirname $hbase_file)
      sudo cp -v $hadoop_file $hadoop2hbase/jars
    done
  done
  mkdir -p $hadoop2hbase/native
  cp -v $HADOOP_HOME/lib/native/* $hadoop2hbase/native
          
  echo "HBASE $HBASE_VER HAS BEEN SUCCESSFULLY INSTALLED AND CONFIGURED"
else
  echo "HBASE $HBASE_VER IS ALREADY INSTALLED"
fi

echo "*** CONFIGURING ENVIRONMENT TO USE HBASE $HBASE_VER ***"
addEnvVarExportToFile HBASE_HOME /usr/local/hbase-$HBASE_VER /etc/profile
addLineToFile 'export PATH=$PATH:$HBASE_HOME/bin' /etc/profile
addEnvVarExportToFile HBASE_VER $HBASE_VER /etc/profile
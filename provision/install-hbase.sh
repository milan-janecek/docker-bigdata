#!/bin/bash

BASE_DIR=${BASE_DIR:-$(dirname $0)/..}
source $BASE_DIR/cluster/scripts/functions.sh

if [ $# -ne 3 ]; then
  echo "ERROR: Exactly 4 arguments are needed: mirror, version, sha1_checksum."
  exit 1
fi

mirror=$1
ver=$2
sha1_checksum=$3

echo "*** SCRIPT ARGUMENTS ***"
echo "mirror: $1"
echo "version: $2"
echo "sha1_checksum: $3"

echo "*** INSTALLING HBASE $ver ***"
if [ ! -d /usr/local/hbase-$ver ]; then

  if [ ! -f $BASE_DIR/software/hbase/hbase-$ver-bin.tar.gz ]; then
    echo "DOWNLOADING HBASE" 
    sudo curl -o $BASE_DIR/software/hbase/hbase-$ver-bin.tar.gz \
      $mirror/$ver/hbase-$ver-bin.tar.gz
  
    echo "VALIDATING CHECKSUM"
    echo "$sha1_checksum $BASE_DIR/software/hbase/hbase-$ver-bin.tar.gz" | sha1sum -c -
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
      rm -rf $BASE_DIR/software/hbase/hbase-$ver-bin.tar.gz
      echo "CHECKSUM VALIDATION FAILED - HBASE $ver HAS NOT BEEN INSTALLED"
      exit $exit_status
    else
      echo "CHECKSUM IS OK"
    fi
  fi
  
  echo "EXTRACTING HBASE ARCHIVE"
  sudo tar -zxf $BASE_DIR/software/hbase/hbase-$ver-bin.tar.gz -C /usr/local
  
  echo "*** REPLACING HADOOP JARS FOR LOCAL INSTALL AND MOVING HADOOP JARS TO DOCKER CONTEXT FOLDER ***"
  hbase_home=/usr/local/hbase-$ver
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
          
  echo "HBASE $ver HAS BEEN SUCCESSFULLY INSTALLED AND CONFIGURED" 
else
  echo "HBASE $ver IS ALREADY INSTALLED" 
fi

echo "*** CONFIGURING ENVIRONMENT TO USE HBASE $ver ***"
profileFile="/etc/profile.d/hbase.sh"
sudo rm -rf $profileFile
addLineToFile "export HBASE_HOME=/usr/local/hbase-$ver" $profileFile
addLineToFile 'export PATH=$PATH:$HBASE_HOME/bin' $profileFile
addLineToFile "export HBASE_VER=$ver" $profileFile
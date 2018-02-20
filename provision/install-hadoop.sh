#!/bin/bash

BASE_DIR=${BASE_DIR:-$(dirname $0)/..}
source $BASE_DIR/cluster/scripts/functions.sh

if [ $# -ne 3 ]; then
  echo "ERROR: Exactly 3 arguments are needed: mirror, version, sha1_checksum."
  exit 1
fi

mirror=$1
ver=$2
sha1_checksum=$3

echo "*** SCRIPT ARGUMENTS ***"
echo "mirror: $1"
echo "version: $2"
echo "sha1_checksum: $3"

echo "*** INSTALLING HADOOP $ver ***"
if [ ! -d /usr/local/hadoop-$ver ]; then

  if [ ! -f $BASE_DIR/software/hadoop/hadoop-$ver.tar.gz ]; then
    echo "DOWNLOADING HADOOP" 
    sudo curl -o $BASE_DIR/software/hadoop/hadoop-$ver.tar.gz \
      $mirror/hadoop-$ver/hadoop-$ver.tar.gz
  
    echo "VALIDATING CHECKSUM"
    echo "$sha1_checksum $BASE_DIR/software/hadoop/hadoop-$ver.tar.gz" | sha1sum -c -
    exit_status=$?
    if [ $exit_status -ne 0 ]; then
      rm -rf $BASE_DIR/software/hadoop/hadoop-$ver.tar.gz
      echo "CHECKSUM VALIDATION FAILED - HADOOP $ver HAS NOT BEEN INSTALLED"
      exit $exit_status
    else
      echo "CHECKSUM IS OK"
    fi
  fi
  
  echo "EXTRACTING HADOOP ARCHIVE"
  sudo tar -zxf $BASE_DIR/software/hadoop/hadoop-$ver.tar.gz -C /usr/local
    
  echo "HADOOP $ver HAS BEEN SUCCESSFULLY INSTALLED AND CONFIGURED" 
else
  echo "HADOOP $ver IS ALREADY INSTALLED" 
fi

echo "*** CONFIGURING ENVIRONMENT TO USE HADOOP $ver ***"
profileFile="/etc/profile.d/hadoop.sh"
sudo rm -rf $profileFile
addLineToFile "export HADOOP_HOME=/usr/local/hadoop-$ver" $profileFile
addLineToFile 'export PATH=$PATH:$HADOOP_HOME/bin' $profileFile
addLineToFile "export HADOOP_VER=$ver" $profileFile
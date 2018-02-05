#!/bin/bash

if [ $# -ne 4 ]; then
  echo "ERROR: Exactly 4 arguments are needed: mirror, version, sha1_checksum, hadoop_ver."
  exit 1
fi

BASE_DIR=${BASE_DIR:-$(pwd)/..}

mirror=$1
ver=$2
sha1_checksum=$3
hadoop_ver=$4

echo "*** SCRIPT ARGUMENTS ***"
echo "mirror: $1"
echo "version: $2"
echo "sha1_checksum: $3"
echo "hadoop_ver: $4"

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
  
  $BASE_DIR/provision/hbase-replace-hadoop-jars.sh \
    /usr/local/hbase-$ver \
    /usr/local/hadoop-$hadoop_ver
          
  echo "HBASE $ver HAS BEEN SUCCESSFULLY INSTALLED AND CONFIGURED" 
else
  echo "HBASE $ver IS ALREADY INSTALLED" 
fi

echo "*** CONFIGURING ENVIRONMENT TO USE HBASE $ver ***"
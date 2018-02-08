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
  
  echo "*** REPLACING HADOOP JARS AND PREPARING DOCKER BUILD PROCESS ***"
  hbase_home=/usr/local/hbase-$ver
  hadoop_home=/usr/local/hadoop-$hadoop_ver
  hadoop2hbase=$BASE_DIR/software/hbase/hadoop/$hadoop_ver
  mkdir -p $hadoop2hbase/jars
  find $hbase_home -name "hadoop-*.jar" | while read hbase_file; do
    filepattern=$(echo $(basename $hbase_file) | sed 's/[0-9].[0-9].[0-9]/[0-9].[0-9].[0-9]/')
    find $hadoop_home -regex "$hadoop_home/.*$filepattern" | while read hadoop_file; do
      sudo rm -rf $hbase_file
      sudo cp -v $hadoop_file $(dirname $hbase_file)
      sudo cp -v $hadoop_file $hadoop2hbase/jars
    done
  done
  mkdir -p $hadoop2hbase/native
  cp -v $hadoop_home/lib/native/* $hadoop2hbase/native
  
  echo "COPYING HDFS-SITE.XML TO HBASE CONF DIR"
  sudo cp -v $hadoop_home/etc/hadoop/core-site.xml $hbase_home/conf
  sudo cp -v $hadoop_home/etc/hadoop/hdfs-site.xml $hbase_home/conf
  
  echo "COPYING HBASE CONFIGURATION FILES FROM SHARE TO HBASE CONF DIR"
  sudo cp -v $BASE_DIR/software/hbase/share/conf/* $hbase_home/conf
          
  echo "HBASE $ver HAS BEEN SUCCESSFULLY INSTALLED AND CONFIGURED" 
else
  echo "HBASE $ver IS ALREADY INSTALLED" 
fi

echo "*** CONFIGURING ENVIRONMENT TO USE HBASE $ver ***"
echo "ADDING HBASE BIN TO PATH"
sudo sh -c \
  'echo export PATH=\$PATH:/usr/local/hbase-'$ver'/bin > /etc/profile.d/hbase-bin.sh'
  
echo "SETTING HBASE_VER"
sudo sh -c \
  "echo export HBASE_VER=$ver > /etc/profile.d/hbase-ver.sh"
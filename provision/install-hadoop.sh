#!/bin/bash

if [ $# -ne 3 ]; then
  echo "ERROR: Exactly 3 arguments are needed: mirror, version, sha1_checksum."
  exit 1
fi

BASE_DIR=${BASE_DIR:-$(pwd)/..}

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
  
  echo "COPYING HADOOP CONFIGURATION FILES FROM SHARE TO HADOOP CONF DIR"
  sudo cp -v $BASE_DIR/software/hadoop/share/conf/* /usr/local/hadoop-$ver/etc/hadoop
    
  echo "HADOOP $ver HAS BEEN SUCCESSFULLY INSTALLED AND CONFIGURED" 
else
  echo "HADOOP $ver IS ALREADY INSTALLED" 
fi

echo "*** CONFIGURING ENVIRONMENT TO USE HADOOP $ver ***"
echo "SETTING HADOOP_HOME"
sudo sh -c \
  "echo export HADOOP_HOME=/usr/local/hadoop-$ver > /etc/profile.d/hadoop-home.sh"
  
echo "ADDING HADOOP BIN TO PATH"
sudo sh -c \
  'echo export PATH=\$PATH:/usr/local/hadoop-'$ver'/bin > /etc/profile.d/hadoop-bin.sh'
  
echo "SETTING HADOOP_VER"
sudo sh -c \
  "echo export HADOOP_VER=$ver > /etc/profile.d/hadoop-ver.sh"
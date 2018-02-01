#!/bin/bash

mirror=$1
ver=$2
checksum=$3

echo "*** INSTALLING HADOOP ***"

echo "DOWNLOADING HADOOP $2 from $1"

sudo curl -o /vagrant/hadoop/hadoop.tar.gz \
  $mirror/hadoop-$ver/hadoop-$ver.tar.gz

echo "VALIDATING CHECKSUM"

echo "$checksum /vagrant/hadoop/hadoop.tar.gz" | sha1sum -c -
exit_status=$?
if [ $exit_status -ne 0 ]; then
  echo "CHECKSUM VALIDATION FAILED"
  exit $exit_status
else
  echo "CHECKSUM IS OK"
fi

echo "EXTRACTING HADOOP ARCHIVE TO /usr/local/hadoop"

tar -zxf /vagrant/hadoop/hadoop.tar.gz -C /usr/local
sudo mv /usr/local/hadoop-* /usr/local/hadoop

echo "MODIFYING ENVIRONMENT VARIABLES"

sudo sh -c \
  'echo export HADOOP_HOME=/usr/local/hadoop >> /etc/profile.d/vagrant.sh'
sudo sh -c \
  'echo export PATH=\$PATH:/usr/local/hadoop/bin >> /etc/profile.d/vagrant.sh'
  
echo "COPYING HADOOP CONFIGURATION FILES FROM SHARE TO HADOOP CONF DIR"

sudo cp -v /vagrant/hadoop/share/conf/* /usr/local/hadoop/etc/hadoop

echo "MODIFYING HADOOP CONFIGURATION FILES"

sudo sed -i -r "s/([a-zA-Z0-9.]{1,})(:[0-9]{1,})/localhost\2/g" \
  /usr/local/hadoop/etc/hadoop/hdfs-site.xml
sudo sed -i -r "s/([a-zA-Z0-9.]{1,})(:[0-9]{1,})/localhost\2/g" \
  /usr/local/hadoop/etc/hadoop/yarn-site.xml
sudo sed -i -r "s/([a-zA-Z0-9.]{1,})(:[0-9]{1,})/localhost\2/g" \
  /usr/local/hadoop/etc/hadoop/mapred-site.xml
  
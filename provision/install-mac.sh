#!/bin/bash

BASE_DIR=${BASE_DIR:-$(pwd)/..}
source $BASE_DIR/cluster/scripts/functions.sh

source install-hadoop.sh

source install-hbase.sh

source install-zookeeper.sh

source install-spark.sh

source build-images.sh

source post-install.sh

addLineToFile "export CLUSTER_ON_MAC=1" /etc/profile

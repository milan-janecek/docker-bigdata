#!/bin/bash

BASE_DIR=${BASE_DIR:-$(pwd)/..}

sudo sh -c \
  'echo export PATH=\$PATH:'$BASE_DIR'/cluster > /etc/profile.d/cluster.sh'

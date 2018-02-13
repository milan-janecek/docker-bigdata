#!/bin/bash

BASE_DIR=${BASE_DIR:-$(pwd)/..}

sudo sh -c \
  'echo export PATH=\$PATH:'$BASE_DIR'/cluster > /etc/profile.d/cluster.sh'
  
sudo sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/' /etc/default/grub

sudo update-grub

sudo apt-get install htop

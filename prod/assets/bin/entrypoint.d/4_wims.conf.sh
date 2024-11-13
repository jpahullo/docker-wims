#!/bin/bash

id

# For all environments: create required wims.conf file if missing.
if  [ ! -f /home/wims/log/wims.conf ];
then
  echo "threshold1=$(($(cat /proc/cpuinfo | grep processor | wc -l) * 150))" > log/wims.conf
  echo "threshold2=$(($(cat /proc/cpuinfo | grep processor | wc -l) * 300))" >> log/wims.conf
else
  # Update threshold values, just in case the number of CPU/vCPU has changed since last boot.
  ncpus=$(cat /proc/cpuinfo | grep processor | wc -l);
  threshold1=$(($ncpus * 150));
  sed -i "s/threshold1=.*/threshold1=$threshold1/g" log/wims.conf
  threshold2=$(($ncpus * 300));
  sed -i "s/threshold2=.*/threshold2=$threshold2/g" log/wims.conf
fi;

# Invariant: we must be sure of these permissions, or we cannot enter into administration.
chown wims:wims log/wims.conf
chmod go-rwx log/wims.conf

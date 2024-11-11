#!/bin/bash

# For all environments: create required wims.conf file if missing.
if  [ ! -f /home/wims/log/wims.conf ];
then
  echo "threshold1=$(($(cat /proc/cpuinfo | grep processor | wc -l) * 150))" > log/wims.conf
  echo "threshold2=$(($(cat /proc/cpuinfo | grep processor | wc -l) * 300))" >> log/wims.conf
  chown wims:wims log/wims.conf
  chmod go-rwx log/wims.conf
fi;

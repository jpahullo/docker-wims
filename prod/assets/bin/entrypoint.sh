#!/bin/bash

# Scripts under actions/ paths have available APP_ENV to check if it has to be
# executed on this case. Do not check APP_ENV if it has to be run always,
# no matter if it is on a production or testing environment.
for action in $(dirname $0)/entrypoint.d/*.sh;
do
  # For debugging purposes.
  echo "[ENTRYPOINT] Processing $action...";
  # Start it in a subprocess, to be protected against unintentional exit commands.
  ("$action");
done;

# Execute always this step in the end to keep the container working.
apachectl -D FOREGROUND

#!/bin/bash

if [ "$APP_ENV" != "prod" ];
then
  # Nothing to do.
  exit 0;
fi;

a2enconf security

#!/bin/bash

if [ "$APP_ENV" != "prod" ];
then
  # Nothing to do.
  exit 0;
fi;

# Logs redirection.
# Non error logs.
ln -sf /proc/1/fd/1 /home/wims/log/access.log
ln -sf /proc/1/fd/1 /home/wims/log/post.log
ln -sf /proc/1/fd/1 /home/wims/log/referer.log
ln -sf /proc/1/fd/1 /home/wims/log/referer/refsite.log
ln -sf /proc/1/fd/1 /home/wims/log/referer/refstem.log
ln -sf /proc/1/fd/1 /home/wims/log/referer/refuniq.log
ln -sf /proc/1/fd/1 /home/wims/log/session.log
ln -sf /proc/1/fd/1 /home/wims/tmp/log/backup.log
ln -sf /proc/1/fd/1 /home/wims/tmp/log/cc.log
ln -sf /proc/1/fd/1 /home/wims/tmp/log/housekeep.log
ln -sf /proc/1/fd/1 /home/wims/tmp/log/modupdate.log

# Error logs.
ln -sf /proc/1/fd/2 /home/wims/log/module_error.log
ln -sf /proc/1/fd/2 /home/wims/log/user_error.log

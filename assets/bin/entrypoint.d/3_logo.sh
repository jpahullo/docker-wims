#!/bin/bash

# For all environments: set the logo.
#   1. If log/logo.jpeg exists, then it is copied to be visible on the web.
#   2. Otherwise, the logo is removed.
if [ -f /home/wims/log/logo.jpeg ]; then
  cp /home/wims/log/logo.jpeg /home/wims/public_html/logo.jpeg
  chown wims:wims /home/wims/public_html/logo.jpeg
else
  rm -f /home/wims/public_html/logo.jpeg
fi

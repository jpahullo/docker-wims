#!/bin/bash
SSMTP_MAILHUB=${SSMTP_MAILHUB:-localhost}
cat > /etc/ssmtp/ssmtp.conf <<EOF
mailhub=$SSMTP_MAILHUB
hostname=$SSMTP_HOSTNAME
EOF

if [ -f /home/wims/log/logo.jpeg ]; then
  cp /home/wims/log/logo.jpeg /home/wims/public_html/logo.jpeg
  chown wims:wims /home/wims/public_html/logo.jpeg
else
  rm -f /home/wims/public_html/logo.jpeg
fi

if  [ ! -f /home/wims/log/wims.conf ];  then
  echo "threshold1=$(($(cat /proc/cpuinfo | grep processor | wc -l) * 150))" > log/wims.conf
  echo "threshold2=$(($(cat /proc/cpuinfo | grep processor | wc -l) * 300))" >> log/wims.conf
fi

apachectl -D FOREGROUND

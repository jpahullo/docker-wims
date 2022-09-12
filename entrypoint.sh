#!/bin/bash
SSMTP_MAILHUB=${SSMTP_MAILHUB:-localhost}
cat > /etc/ssmtp/ssmtp.conf <<EOF
mailhub=$SSMTP_MAILHUB
hostname=$SSMTP_HOSTNAME
EOF

if [ "$REVERSE_PROXY" != "" ]; then
  echo 'SetEnvIf X-Forwarded-Proto "https" HTTPS=on' > /etc/apache2/conf-enabled/http-proto.conf
  echo 'RemoteIPHeader X-Forwarded-For' >> /etc/apache2/conf-enabled/http-proto.conf
  echo "RemoteIPInternalProxy $(ip route | awk '/default/ { print $3 }')" >> /etc/apache2/conf-enabled/http-proto.conf
fi

if [ -f /home/wims/log/logo.jpeg ]; then
  cp /home/wims/log/logo.jpeg /home/wims/public_html/logo.jpeg
  chown wims:wims /home/wims/public_html/logo.jpeg
else
  rm -f /home/wims/public_html/logo.jpeg
fi

if  [ ! -f /home/wims/log/wims.conf ];  then
  echo "threshold1=$(($(cat /proc/cpuinfo | grep processor | wc -l) * 150))" > log/wims.conf
  echo "threshold2=$(($(cat /proc/cpuinfo | grep processor | wc -l) * 300))" >> log/wims.conf
  chown wims.wims log/wims.conf
  chmod go-rwx log/wims.conf
fi

apachectl -D FOREGROUND

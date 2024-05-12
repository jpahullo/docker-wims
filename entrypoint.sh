#!/bin/bash
SSMTP_MAILHUB=${SSMTP_MAILHUB:-localhost}
cat > /etc/ssmtp/ssmtp.conf <<EOF
mailhub=$SSMTP_MAILHUB
hostname=$SSMTP_HOSTNAME
EOF

rm -f /etc/apache2/conf-enabled/http-proto.conf
if [ "$REVERSE_PROXY" != "" ]; then
  echo 'SetEnvIf X-Forwarded-Proto "https" HTTPS=on' > /etc/apache2/conf-enabled/http-proto.conf
  echo 'RemoteIPHeader X-Forwarded-For' >> /etc/apache2/conf-enabled/http-proto.conf
  echo "RemoteIPInternalProxy $REVERSE_PROXY" >> /etc/apache2/conf-enabled/http-proto.conf
  echo 'Waiting that reverse proxy is resolvable'
  until getent hosts "$REVERSE_PROXY" > /dev/null; do sleep 5; done
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

#!/bin/sh
echo "Configuring nginx..."

mkdir -p /etc/nginx/conf.d

#Generate Diffie-Hellman key
if [ ! -f /etc/nginx/ssl/dh2048.pem ]; then
    mkdir -p /etc/nginx/ssl
    cd /etc/nginx/ssl
    openssl dhparam -out dh2048.pem 2048
    chmod 600 dh2048.pem
    echo "Successful created dh2048.pem"
fi


# Set key paths
echo "your domain=${DOMAIN:=$DOMAIN}"
echo "your email=${EMAIL:=$EMAIL}"
FILE_KEY=/etc/nginx/ssl/certificates/${DOMAIN}.key
FILE_CRT=/etc/nginx/ssl/certificates/${DOMAIN}.crt
echo "your SSL_KEY=${FILE_KEY}"
echo "your SSL_CRT=${FILE_CRT}"
cp -f /etc/nginx/service-ssl.conf /etc/nginx/conf.d/service-ssl.conf

sed -i "s|FILE_KEY|${FILE_KEY}|g" /etc/nginx/conf.d/service-ssl.conf
sed -i "s|FILE_CRT|${FILE_CRT}|g" /etc/nginx/conf.d/service-ssl.conf

mv -v /etc/nginx/conf.d /etc/nginx/conf.d.old
(
while :
do
  sleep 10

  if [ ! -f /etc/nginx/ssl/certificates/${DOMAIN}.key ]; then
    lego -a --path=/etc/nginx/ssl --email="${EMAIL}" --domains="${DOMAIN}" --domains="www.${DOMAIN}" --http=:81 run #Generate new certificates
  else
    lego -a --path=/etc/nginx/ssl --email="${EMAIL}" --domains="${DOMAIN}" --domains="www.${DOMAIN}" --http=:81 renew #Update certificates
  fi
  mv -v /etc/nginx/conf.d.old /etc/nginx/conf.d
  echo "Restart nginx..."
  nginx -s reload
  sleep 80d
done
)&

nginx -g "daemon off;"
exit $?

#!/bin/sh
echo "Configuring nginx..."

#Generate Diffie-Hellman key
if [ ! -f /etc/nginx/ssl/dh4096.pem ]; then
    mkdir -p /etc/nginx/ssl
    cd /etc/nginx/ssl
    openssl dhparam -out dh4096.pem 4096
    chmod 600 dh4096.pem
    echo "Successful created dh4096.pem"
fi


# Set key paths
echo "your domain=${DOMAIN:=$DOMAIN}"
echo "your email=${EMAIL:=$EMAIL}"
FILE_KEY=/etc/nginx/ssl/certificates/${DOMAIN}.key
FILE_CRT=/etc/nginx/ssl/certificates/${DOMAIN}.crt
echo "your SSL_KEY=${FILE_KEY}"
echo "your SSL_CRT=${FILE_CRT}"
cp -f /etc/nginx/service-ssl.conf /etc/nginx/conf.d/service-ssl.conf

sed -i "s|FILE_KEY|${FILE_KEY}|g" /etc/nginx/conf.d/service.conf
sed -i "s|FILE_CRT|${FILE_CRT}|g" /etc/nginx/conf.d/service.conf


(
while :
do
  sleep 10

  if [ ! -f /etc/nginx/ssl/certificates/${DOMAIN}.key ]; then
    lego -a --path=/etc/nginx/ssl --email="${EMAIL}" --domains="${DOMAIN}" --domains="www.${DOMAIN}" --http=:80 run #Generate new certificates
  else
    lego -a --path=/etc/nginx/ssl --email="${EMAIL}" --domains="${DOMAIN}" --domains="www.${DOMAIN}" --http=:80 --tls=:443 renew #Update certificates
  fi

  sleep 80d
  echo "Restart nginx..."
  nginx -s reload
done
)&

nginx -g "daemon off;"
exit $?

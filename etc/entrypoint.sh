#!/bin/sh
echo "Configuring nginx..."
echo "LETSENCRYPT=${LETSENCRYPT:=$LETSENCRYPT}"

if [ ${LETSENCRYPT} != "true" ]; then
    echo "Cerificates is disabled"
    sed -i "s|return 301 https://\$host\$request_uri|index index.html index.htm|g" /etc/nginx/nginx.conf
    nginx -g "daemon off;"
    return 1
fi

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
FILE_KEY=/etc/nginx/ssl/certificates/_.${DOMAIN}.key
FILE_CRT=/etc/nginx/ssl/certificates/_.${DOMAIN}.crt
echo "your SSL_KEY=${FILE_KEY}"
echo "your SSL_CRT=${FILE_CRT}"

if [ -f /etc/nginx/service-ssl.conf ]; then
    mv -f /etc/nginx/service-ssl.conf /etc/nginx/conf.d/service-ssl.conf
fi

sed -i "s|FILE_KEY|${FILE_KEY}|g" /etc/nginx/conf.d/service-ssl.conf
sed -i "s|FILE_CRT|${FILE_CRT}|g" /etc/nginx/conf.d/service-ssl.conf

(
while :
do
  mv -v /etc/nginx/conf.d /etc/nginx/conf.d.old
  sleep 10
  if [ ! -f /etc/nginx/ssl/certificates/_.${DOMAIN}.key ]; then
    if [ ${DNS} != "" ]
      lego -a --path=/etc/nginx/ssl --email="${EMAIL}" --domains="*.${DOMAIN}" --domains="${DOMAIN}" --domains="www.${DOMAIN}" --dns="${DNS}" --http=:81 run #Generate new certificates
    else
      lego -a --path=/etc/nginx/ssl --email="${EMAIL}" --domains="*.${DOMAIN}" --domains="${DOMAIN}" --domains="www.${DOMAIN}" --http=:81 run #Generate new certificates
    fi  
  else
    if [ ${DNS} != "" ]
      lego -a --path=/etc/nginx/ssl --email="${EMAIL}" --domains="*.${DOMAIN}" --domains="${DOMAIN}" --domains="www.${DOMAIN}" --dns="${DNS}" --http=:81 renew #Update certificates
    else
      lego -a --path=/etc/nginx/ssl --email="${EMAIL}" --domains="*.${DOMAIN}" --domains="${DOMAIN}" --domains="www.${DOMAIN}" --http=:81 renew #Update certificates
    fi
  fi
  mv -v /etc/nginx/conf.d.old /etc/nginx/conf.d
  echo "Restart nginx..."
  nginx -s reload
  sleep 80d
done
)&

nginx -g "daemon off;"
exit $?

#!/bin/sh
echo "Configuring nginx..."

#Generate Diffie-Hellman key
if [ ! -f /etc/nginx/ssl/dh4096.pem ]; then
    mkdir -p /etc/nginx/ssl
    cd /etc/nginx/ssl
#    openssl dhparam -out dh4096.pem 4096
  #  chmod 600 dh4096.pem
    echo "Successful created dh4096.pem"
fi

# Set key paths
echo "your domain=${DOMAIN:=$DOMAIN}"
echo "your email=${EMAIL:=$EMAIL}"
FILE_KEY=/etc/nginx/ssl/certificates/${DOMAIN}.key
FILE_CRT=/etc/nginx/ssl/certificates/${DOMAIN}.crt
echo "your SSL_KEY=${FILE_KEY}"
echo "your SSL_CRT=${FILE_CRT}"
cp -f /etc/nginx/service-ssl.conf /etc/nginx/conf.d/service.conf
(
sed -i "s|FILE_KEY|${FILE_KEY}|g" /etc/nginx/conf.d/service.conf
sed -i "s|FILE_CRT|${FILE_CRT}|g" /etc/nginx/conf.d/service.conf
)
nginx -g "daemon off;"
nginx -s reload
echo "Restart nginx..."


# while :
# do
# done
exit $?

#lego -a --path=/etc/nginx/ssl --email="theshamuel@gmail.com" --domains="shamuel.com" --domains="www.shamuel.com" --http=:80 run
#
#do
#lego -a --path=/etc/nginx/ssl --email="theshamuel@gmail.com" --domains="shamuel.com" --domains="www.shamuel.com" --http=:81 --tls=:443 renew
#lego -a --webroot /usr/share/nginx/html --path=/etc/nginx/ssl --email="theshamuel@gmail.com" --domains="shamuel.com" --domains="www.shamuel.com" --http=:81 revoke

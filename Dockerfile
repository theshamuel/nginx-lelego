FROM nginx:stable-alpine

ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD etc/entrypoint.sh /entrypoint.sh
ENV GOPATH /go

 RUN apk add -U openssl && \
     apk add -U ca-certificates && \
     apk add -U git && \
     apk add -U go && \
     go get -u github.com/xenolf/lego && \
     cd /go/src/github.com/xenolf/lego && \
     go build -o /usr/bin/lego . && \
     apk del go git && \
     rm -rf /var/cache/apk/* && \
     rm -rf /go && \
     rm /etc/nginx/conf.d/default.conf && \
     chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]

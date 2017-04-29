FROM nginx:1.13-alpine

ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD etc/entrypoint.sh /entrypoint.sh
ENV GOPATH /go

 RUN apk add -U openssl && \
     apk add -U ca-certificates && \
     apk add -U git && \
     apk add -U libc-dev && \
     apk add -U go && \
     go get -u -f -d github.com/xenolf/lego && \
     go get -u -f -d  github.com/theshamuel/lego && \
     cd /go/src/github.com/theshamuel/lego && \
     cp -r ./providers/dns/azure/azure.go /go/src/github.com/xenolf/lego/providers/dns/azure/azure.go && \
     go build -o /usr/bin/lego . && \
     apk del go git && \
     rm -rf /var/cache/apk/* && \
     rm -rf /go && \
     rm -rf /etc/nginx/conf.d/* && \
     chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]

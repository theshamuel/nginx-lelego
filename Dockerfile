FROM nginx:1.15.8-alpine

ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/service-template.conf /etc/nginx/service-ssl.conf

ADD etc/entrypoint.sh /entrypoint.sh
ENV GOPATH /go

 RUN apk add -U openssl && \
     apk add -U ca-certificates && \
     apk add -U curl && \
    #  apk add -U git && \
     apk add -U libc-dev && \
    #  apk add -U go && \
    cd /tmp && \
    curl -LkO https://github.com/xenolf/lego/releases/download/v1.2.1/lego_v1.2.1_linux_amd64.tar.gz && \
    tar -xvf /tmp/lego_v1.2.1_linux_amd64.tar.gz -C /usr/bin/ && \
    #  go get -u github.com/xenolf/lego && \
    #  cd /go/src/github.com/xenolf/lego && \
    #  go build -o /usr/bin/lego . && \
    #  apk del go git && \
    #  rm -rf /var/cache/apk/* && \
    #  rm -rf /go && \
     rm -rf /etc/nginx/conf.d/* && \
     chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]

FROM nginx:1.13-alpine

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
    curl -Lko /tmp/lego.tar.gz https://github.com/xenolf/lego/releases/download/v1.0.1/lego_v1.0.1_linux_amd64.tar.gz && \
    tar -zxf /tmp/lego.tar.gz -C /usr/bin/ && \
    #  go get -u github.com/xenolf/lego && \
    #  cd /go/src/github.com/xenolf/lego && \
    #  go build -o /usr/bin/lego . && \
    #  apk del go git && \
    #  rm -rf /var/cache/apk/* && \
    #  rm -rf /go && \
     rm -rf /etc/nginx/conf.d/* && \
     chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]

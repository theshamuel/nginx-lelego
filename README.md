## nginx-lelego - nginx with let's encrypt certificate 
[![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)](https://cloud.docker.com/u/theshamuel/repository/docker/theshamuel/nginx-lelego) 

Nginx image (alpine 3.5 installed) with [Let's Encrypt](https://letsencrypt.org "Let's Encrypt Homepage").
Let's Encrypt client which gets certificates is [LEGO](https://github.com/xenolf/lego "GitHub repository")

Autobuilded [image](https://hub.docker.com/r/theshamuel/nginx-lelego/) on docker-hub.

## TUTORIAL

1. Set enviroment varibles in docker-compose.yml
   * `EMAIL` - email for authorisation Let's Encrypt client (ex. email@email.com)
   * `DOMAIN` - domain which gets certificate (ex. domain.com)
   
2. Execute command `docker run --name nginx-shamuel --restart=always --env EMAIL=email@email.com --env DOMAIN=domain.com -p 80:80 -p 443:443 theshamuel/nginx-lelego` or `docker-compose up` after clone the repository

_Thanks [umputun/nginx-le](https://github.com/umputun/nginx-le) for right ideas_

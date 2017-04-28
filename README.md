## nginx-lelego - nginx with let's encrypt certificate
Nginx image (alpine-stable installed) with [Let's Encrypt](https://letsencrypt.org "Let's Encrypt Homepage").

Let's Encrypt client which gets certificates is [LEGO](https://github.com/xenolf/lego "GitHub repository")

Docker-Hub Image -  [image](https://hub.docker.com/r/theshamuel/nginx-lelego/~/dockerfile/)

## TUTORIAL

1. Set enviroment varibles in docker-compose.yml
   * `EMAIL` - email for authorisation Let's Encrypt client (ex. email@email.com)
   * `DOMAIN` - domain which gets certificate (ex. domain.com)
   
2. Execute command `docker-compose up`

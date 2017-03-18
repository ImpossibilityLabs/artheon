# Artheon
Public API server to load artworks from a public domain, build on [Phoenix Framework](http://phoenixframework.org).

Artheon is integrated with [Let's Encrypt](https://letsencrypt.org/) and automatically generates it's SSL certificate then deployed.

Currently it uses [Artsy](https://www.artsy.net/) to populate it's database, uses custom [library](https://github.com/ImpossibilityLabs/artsy).

## Installation
Application is distributed as docker container, so you need to pass your unique credentials as ENVIRONMENT variables.

Container on [docker hub](https://hub.docker.com): `impossibilitylabs/artheon:latest`

### docker-compose

Sample config, replace stars with your custom secure settings:

    version: '2'
    services:
        mysql:
            image: mysql:5.7.16
            restart: always
            ports: 
                - "3306:3306"
            volumes:
                - /root/data/mysql:/var/lib/mysql
            environment:
                - MYSQL_DATABASE=artheon
                - MYSQL_PASSWORD=*************
                - MYSQL_ROOT_PASSWORD=*******************
                - MYSQL_USER=artheon
    
        phoenix:
            image: impossibilitylabs/artheon:latest
            restart: always
            hostname: phoenix
            ports: 
                - "80:80"
                - "443:443"
            links:
                - mysql
            depends_on:
                - mysql
            volumes:
                - /root/data/letsencrypt:/etc/letsencrypt
            command: mix start YOUR.DOMAIN
            environment:
                - DOMAIN=YOUR.DOMAIN
                - ENDPOINT_SECRET=****************
                - MIX_ENV=prod
                - MYSQL_DATABASE=artheon
                - MYSQL_HOSTNAME=mysql
                - MYSQL_PASSWORD=**********************
                - MYSQL_USERNAME=artheon
                - ARTSY_API_URL=https://api.artsy.net/api
                - ARTSY_CLIENT_ID=*****************
                - ARTSY_CLIENT_SECRET=*****************
                - NODE_ENV=production
                - PORT=80
                - SSL_PORT=443

### Endpoint
Set your website port, domain and secret key.

* `PORT`: 80
* `SSL_PORT`: 443
* `DOMAIN`: local.artheon.com
* `SECRET`: *********

### Database
Set your database credentials to environment variables of your docker container.

* `MYSQL_USERNAME`: artheon
* `MYSQL_PASSWORD`: *******
* `MYSQL_DATABASE`: artheon
* `MYSQL_HOSTNAME`: mysql

### Artsy
Set your Artsy credentials to environment variables of your docker container.

* `ARTSY_API_URL`: `https://api.artsy.net/api` Artsy API url,
* `ARTSY_CLIENT_ID`: Artsy application client id,
* `ARTSY_CLIENT_SECRET`: Artsy application secret.

### Database

* Run `mix artsy load` to populate your local database with artworks.

## Usage

### Artworks

Searchable fields: `title`, `category`, `medium`, `date_str`.

Supported query params: `search`, `limit`, `page`, `public_domain`, `paintings_only`.

Sample query: `curl -X GET -H "Accept:application/json" /api/artworks?search=Stone&page=1&limit=10&paintings_only=true&public_domain=true`.

By artist: `curl -X GET -H "Accept:application/json" /api/artworks?artist=vincent&page=1&limit=10&paintings_only=true&public_domain=true`.

# Artheon
Public API server to load artworks from a public domain, build on [Phoenix Framework](http://phoenixframework.org).

Currently it uses [Artsy](https://www.artsy.net/) to populate it's database, uses custom [library](https://github.com/ImpossibilityLabs/artsy).

## Installation
Application is distributed as docker container, so you need to pass your unique credentials as ENVIRONMENT variables.

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

Supported query params: `search`, `limit`, `page`.

Sample query: `curl -X GET -H "Accept:application/json" /api/artworks?search=Stone&page=1&limit=10`.

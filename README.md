# Development applications

[![Continuous Integration](https://github.com/janmartendeboer/development/actions/workflows/ci.yml/badge.svg)](https://github.com/janmartendeboer/development/actions/workflows/ci.yml)

Local development applications using Docker Compose.

This project provides the following applications:

- [`php`](#php)
- [`composer`](#composer)
- [`symfony`](#symfony-cli)
- [`nvm`](#nvm)
- [`node`](#nodejs)
- [`npm`](#npm)

Applications are built as needed, so unused software will not incur a storage or resource penalty on your system.

## Prerequisites

- [Docker Engine](https://docs.docker.com/engine/install/) or [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Docker Compose Plugin](https://docs.docker.com/compose/install/)

## Installation

One can either install through GIT, or by extracting an archive:

- Using [GIT](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git):
  ```shell
  git clone git@github.com:janmartendeboer/development.git "${HOME}/bin"
  ```
- By extracting [the archive](https://github.com/janmartendeboer/development/archive/refs/heads/main.zip)
  ```shell
  wget https://github.com/janmartendeboer/development/archive/refs/heads/main.zip -O - | busybox unzip - \
    && mv development-main "${HOME}/bin"
  ```

Assuming a modern *nix OS, the `${HOME}/bin` location is automatically added to the `$PATH` variable.
If this is not the case for you, manually configure it in your shell profile:

```shell
export PATH="$HOME/bin:$PATH"
```

## Local overrides

When using the software provided by this project, one might want to configure versions, extensions and other
configurables differently from the default provided values.

Both the [`.env.local` env file](https://docs.docker.com/compose/compose-file/05-services/#env_file) and 
[`docker-compose.override.yaml` overrides file](https://docs.docker.com/compose/extends/#multiple-compose-files) can be
used to apply local changes. Both files are ignored by version control. The variables in `.env.local` have precedence 
over variables in `.env`, bot not over variables defined in `services.*.environment`, as per the default Docker Compose
behavior. 

### Custom build args

The following is an example of using a previous version of PHP, with additional PHP extensions, using
`docker-compose.override.yaml`:

```yaml
# docker-compose.override.yaml
services:
  php:
    build:
      args:
        PHP_VERSION: 8.1
        PHP_EXTENSIONS: apcu intl opcache zip pdo_mysql xdebug gd imagick
```

When changing build args using `docker-compose.override.yaml`, make sure the run `docker compose build [service]` to
rebuild that specific service, or `docker compose build` to rebuild changed services.

> **N.B.**: When invoking `docker compose build` without specific service, it will also build services for applications
> that were previously unused. If one previously did not use the `symfony` application, that will now be built.

### Custom environment variables

The following sets a custom location for the local Composer home mount.

```dotenv
# .env.local
COMPOSER_HOME=/path/to/.composer
```

## Environment variables

Environment variables are set in `.env` and can be updated by adding them to `.env.local`.

The following environment variables are available:

| ENV                 | Default                 | Description                                                                                                                               |
|:--------------------|:------------------------|:------------------------------------------------------------------------------------------------------------------------------------------|
| `TMP`               | `/tmp`                  | The host system temporary directory.                                                                                                      |
| `PHP_HOME`          | `/home/www-data`        | The internal home directory for services based on the PHP image. It gets translated to `$HOME` inside those containers.                   |
| `PHP_COMPOSER_HOME` | `${PHP_HOME}/.composer` | The internal home directory for Composer files, used inside PHP services. It gets translated to `$COMPOSER_HOME` inside those containers. |
| `COMPOSER_HOME`     | `${HOME}/.composer`     | The local mount location for Composer files on the host system. This gets mounted to `${PHP_COMPOSER_HOME}` inside PHP services.          |
| `NVM_HOME`          | `${HOME}/.nvm`          | The local mount location for NVM files on the host system. This gets mounted to `/home/app/.nvm` inside the Node services.                |
| `NVM_TMP`           | `${TMP}/.nvm`           | THe local mount location for temporary NVM files. This is used to persist the current Node version between commands.                      |
| `UID`               | `${UID:-1000}`          | The user ID to use when running applications. Make sure to run `docker compose build` when changing its value.                            |
| `GID`               | `${GID:-1000}`          | The group ID to use when running applications. Make sure to run `docker compose build` when changing its value.                           |

## Connecting to a database server

Although this is covered under [Docker Compose networking](https://docs.docker.com/compose/networking/), the following
describes how to ensure the global PHP application could access a containerized service in another Docker Compose project.

In your specific project, ensure the service has an exposed port to connect to. The following shows how to expose a
database server from inside your project:

```yaml
# <project>/docker-compose.override.yaml
services:
  db:
    ports:
      - 3306:3306
```

While inside your project, the database can be accessed using the `db` hostname, this same hostname is not available to
the global `php` application. However, once the port is exposed, this can be solved with an override that registers the
`db` host to the `php` and `composer` applications:

```yaml
# <development>/docker-compose.override.yaml
x-extra-hosts: &extra-hosts
  extra_hosts:
    db: 172.17.0.1 # The IPv4 address of the local Docker network interface

services:
  php:
    <<: *extra-hosts
  composer:
    <<: *extra-hosts
```

To find the address to the local Docker interface, use the following:

```shell
ip a show dev docker0 | grep 'inet ' | awk '{ split($2, a, "/"); print a[1] }'
```

This returns something like `172.17.0.1`.

> **N.B.:** One could also accomplish this by updating the `/etc/hosts` file on the host system, as Docker inherits from
> those hosts. However, doing so produces a valid DNS record for all software on the host system, which is
> discouraged to prevent conflicts and unexpected behavior.

## Applications

The following applications are available after installing this project.

### PHP

E.g.: `php -v`

PHP version and extensions can be configured through `services.php.build.args`.

#### PHP build args

| ARG                | Default               | Description                                                                                                                                                                                                                 |
|:-------------------|:----------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `PHP_VERSION`      | `8.2`                 | A PHP version number, accepted as [tag for the PHP Docker image](https://hub.docker.com/_/php/tags). Versions are automatically suffixed with `-cli-alpine`.                                                                |
| `PHP_INI`          | `php.ini-development` | Relative to `$PHP_INI_DIR` from the [PHP Docker image](https://hub.docker.com/_/php). This determines the file that gets moved to `$PHP_INI_DIR/php.ini`. Suggested values are: `php.ini-development`, `php.ini-production` |
| `PHP_INIS`         | N/A                   | A space delimited list of INI files as found in `docker/php/conf.d/*.ini` and [`docker/php/conf.override.d/*.ini`](docker/php/conf.override.d/README.md).                                                                   |
| `PHP_EXTENSIONS`   | N/A                   | A space delimited list of [PHP extensions](https://github.com/mlocati/docker-php-extension-installer#supported-php-extensions) to install and enable.                                                                       |
| `COMPOSER_VERSION` | `2`                   | A Composer version number, accepted as [tag for the Composer Docker image](https://hub.docker.com/_/composer/tags).                                                                                                         |
| `GIT`              | `0`                   | Set to `1` to install the [GIT](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) application.                                                                                                                 |
| `SYMFONY`          | `0`                   | Set to `1` to install the [Symfony CLI](https://github.com/symfony-cli/symfony-cli) application.                                                                                                                            |
| `UID`              | `$UID`                | Set to the UID of the local user needed for file permissions. Make sure it matches the `$UID` environment variable in `.env.local`.                                                                                         |
| `GID`              | `$GID`                | Set to the GID of the local user needed for file permissions. Make sure it matches the `$GID` environment variable in `.env.local`.                                                                                         |

### Composer

E.q.: `composer -v`

Composer version can be configured through `services.composer.build.args`.
Composer home can be influenced by updating the [`PHP_COMPOSER_HOME` environment variable](#environment-variables).

See also: [PHP build args](#php-build-args)

### Symfony CLI

E.g.: `symfony version`

See also: [PHP build args](#php-build-args)

### NVM

E.g.: `nvm --version`

#### NVM build args

| ARG   | Default | Description                                                                                                                         |
|:------|:--------|:------------------------------------------------------------------------------------------------------------------------------------|
| `APP` | `nvm`   | Set the entrypoint application to invoke when running this service.                                                                 |
| `UID` | `$UID`  | Set to the UID of the local user needed for file permissions. Make sure it matches the `$UID` environment variable in `.env.local`. |
| `GID` | `$GID`  | Set to the GID of the local user needed for file permissions. Make sure it matches the `$GID` environment variable in `.env.local`. |

### NodeJS

E.g.: `node --version`

See also: [NVM build args](#nvm-build-args)

### NPM

E.g.: `npm --version`

See also: [NVM build args](#nvm-build-args)
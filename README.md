# Development applications

Local development applications using Docker Compose.

This project provides the following applications:

- [`php`](#php)
- [`composer`](#composer)
- [`symfony`](#symfony-cli)

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
| `PHP_HOME`          | `/home/www-data`        | The internal home directory for services based on the PHP image. It gets translated to `$HOME` inside those containers.                   |
| `PHP_COMPOSER_HOME` | `${PHP_HOME}/.composer` | The internal home directory for Composer files, used inside PHP services. It gets translated to `$COMPOSER_HOME` inside those containers. |
| `COMPOSER_HOME`     | `${HOME}/.composer`     | The local mount location for Composer files on the host system. This gets mounted to `${PHP_COMPOSER_HOME}` inside PHP services.          |
| `UID`               | `${UID:-1000}`          | The user ID to use when running applications. Make sure to run `docker compose build` when changing its value.                            |
| `GID`               | `${GID:-1000}`          | The group ID to use when running applications. Make sure to run `docker compose build` when changing its value.                           |

## Applications

The following applications are available after installing this project.

### PHP

E.g.: `php -v`

PHP version and extensions can be configured through `services.php.build.args`.

### PHP build args

| ARG                | Default                                       | Description                                                                                                                                                  |
|:-------------------|:----------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `PHP_VERSION`      | `8.2`                                         | A PHP version number, accepted as [tag for the PHP Docker image](https://hub.docker.com/_/php/tags). Versions are automatically suffixed with `-cli-alpine`. |
| `PHP_EXTENSIONS`   | See: `services.php.build.args.PHP_EXTENSIONS` | A space delimited list of [PHP extensions](https://github.com/mlocati/docker-php-extension-installer#supported-php-extensions) to install and enable.        |
| `COMPOSER_VERSION` | `2`                                           | A Composer version number, accepted as [tag for the Composer Docker image](https://hub.docker.com/_/composer/tags).                                          |                                                                               |
| `SYMFONY`          | `0`                                           | Set to `1` to install the [Symfony CLI](https://github.com/symfony-cli/symfony-cli) application.                                                             |
| `GIT`              | `0`                                           | Set to `1` to install the [GIT](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) application.                                                  |
| `UID`              | `$UID`                                        | Set to the UID of the local user needed for file permissions. Make sure it matches the `$UID` environment variable in `.env.local`.                          |
| `GID`              | `$GID`                                        | Set to the GID of the local user needed for file permissions. Make sure it matches the `$GID` environment variable in `.env.local`.                          |

### Composer

E.q.: `composer -v`

Composer version can be configured through `services.composer.build.args`.
Composer home can be influenced by updating the [`PHP_COMPOSER_HOME` environment variable](#environment-variables).

See also: [PHP build args](#php-build-args)

### Symfony CLI

E.g.: `symfony version`

See also: [PHP build args](#php-build-args)
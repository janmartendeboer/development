# Development applications

Local development applications using Docker Compose.

## Prerequisites

- [Docker Engine](https://docs.docker.com/engine/install/)
- [Docker Compose Plugin](https://docs.docker.com/compose/install/)

## Installation

```shell
git clone git@github.com:janmartendeboer/development.git "${HOME}/bin"
```

Assuming a modern *nix OS, the `${HOME}/bin` location is automatically added to the `$PATH` variable.

## Available applications

The following applications are provided.

### PHP

E.g.: `php -v`

PHP version and extensions can be configured through `services.php.build.args`.

### Composer

E.q.: `composer -v`

Composer version can be configured through `services.composer.build.args`.
Composer home can be influenced by updating `PHP_COMPOSER_HOME`

### Symfony CLI

E.g.: `symfony version`
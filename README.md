# Development applications

Local development applications using Docker Compose.

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
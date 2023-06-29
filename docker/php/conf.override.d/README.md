# PHP INI overrides

This folder may contain local additions to the PHP ini files, that are not persisted in version control.

> **Note**: The files in this folder are merged with the `conf.d` folder. Files with the same name in this folder
> override files from the `conf.d` folder inside the PHP images.

If one wants to add additional configuration on top of existing INI configuration inside the `conf.d` folder, make sure
to name the file accordingly. E.g.: `symfony-additions.ini`. This prevents loss of configuration from the original
`symfony.ini` file.

Also, don't forget to add the specific ini file of choice to the `PHP_INIS` build arg in `docker-compose.override.yaml`.

```yaml
services:
  symfony:
    build:
      args:
        PHP_INIS: symfony.ini symfony-additions.ini
```

Alternatively, copy the contents of `symfony.ini` and update or add config as needed, to not need changes in the build 
args.
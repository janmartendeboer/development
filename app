#!/usr/bin/env bash

projectDir="$(dirname -- "${BASH_SOURCE[0]}")";

if [ ! -f "$projectDir/.env.local" ]; then touch "$projectDir/.env.local"; fi

[[ ${TTY:-1} -eq 1 ]] && TTY_FLAG='-it'

# shellcheck disable=SC2068
docker compose --project-directory "$projectDir" run --rm "${TTY_FLAG:--i}" $@;
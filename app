#!/usr/bin/env bash

projectDir="$(dirname -- "$0")";

if [ ! -f "$projectDir/.env.local" ]; then touch "$projectDir/.env.local"; fi

# shellcheck disable=SC2068
docker compose --project-directory "$projectDir" run --rm -it $@;

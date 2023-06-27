#!/usr/bin/env bash
# shellcheck disable=SC2068
docker compose --project-directory "$(dirname -- "$0")" run --rm -it $@;

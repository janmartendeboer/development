#!/usr/bin/env bash
source "${NVM_DIR}/nvm.sh";

# Ensure locally configured versions are honored.
[ -f "${NVM_DIR}/.nvmrc" ] && nvm use "$(cat "${NVM_DIR}/.nvmrc")" &> /dev/null;

# shellcheck disable=SC2068
nvm $@;

# Ensure that Node version changes persist between runs.
if [[ "$1" == "use" ]] && [[ $# -gt 1 ]]; then
  nvm current > "${NVM_DIR}/.nvmrc";
fi
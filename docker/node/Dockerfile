FROM debian:latest

ENV HOME=/home/app

ARG UID=1000
ARG GID=1000

RUN set -eux \
    && groupadd -g $GID app \
    && useradd -m -d "${HOME}" -u $UID -g $GID -s /bin/bash app

ENV NVM_DIR="${HOME}/.nvm"

COPY --link entrypoint /usr/local/bin/entrypoint

RUN set -eux \
    && apt update -y \
    && apt install -y curl \
    && apt autoclean -y \
    && curl -sf https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash \
    && echo '[ -s "${NVM_DIR}/nvm.sh" ] && source "${NVM_DIR}/nvm.sh"' > "${HOME}/.bashrc" \
    && chown -R app:app "${NVM_DIR}" \
    && chmod +x /usr/local/bin/entrypoint

USER app
WORKDIR /app

VOLUME "${NVM_DIR}/alias"
VOLUME "${NVM_DIR}/versions"

ARG APP=nvm
ENV NODE_APP=$APP
ENTRYPOINT ["entrypoint"]
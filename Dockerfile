FROM alpine:3.19.2 AS build
LABEL version="v0.1.5"
LABEL release="pipetools-ansible"
LABEL maintainer="marcinbojko"
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
COPY requirements.yml /tmp/requirements.yml
COPY entrypoint.sh /entrypoint.sh
# shellcheck disable=SC2169
RUN apk update && apk add --no-cache --update -t deps ca-certificates curl bash gettext tar gzip openssl openssh rsync python3 python3-dev py3-pip py3-wheel tzdata git httpie sshfs shellcheck \
libffi libffi-dev py3-setuptools py3-distutils-extra build-base yamllint dos2unix ansible \
&& apk upgrade --no-cache
# separate runs to check space consumption
RUN python3 -m venv /home/ansible;. /home/ansible/bin/activate \
  && pip3 install --no-cache-dir --upgrade jsonlint ansible-lint \
  && rm -rf /root/.cache ||true \
  && mkdir -p ~/.ssh \
  && eval "$(ssh-agent -s)" \
  && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config \
  && chmod -R 700 ~/.ssh \
  && chmod 700 /entrypoint.sh && chmod +x /entrypoint.sh
RUN . /home/ansible/bin/activate;ansible-galaxy collection install -v --force -r /tmp/requirements.yml -p /usr/share/ansible/collections
ENTRYPOINT ["/entrypoint.sh"]


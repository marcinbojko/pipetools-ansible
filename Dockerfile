FROM alpine:3.15.4 AS build
LABEL version="v0.0.4"
LABEL release="pipetools-ansible"
LABEL maintainer="marcinbojko"
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
COPY requirements.yml /tmp/requirements.yml
# shellcheck disable=SC2169
RUN apk update && apk add --no-cache --update -t deps ca-certificates curl bash gettext tar gzip openssl openssh rsync python3 python3-dev py3-pip py3-wheel tzdata git httpie sshfs shellcheck \
  libffi libffi-dev py3-setuptools py3-distutils-extra build-base \
  && apk upgrade --no-cache
# separate runs to check space consumption
RUN pip3 install --no-cache-dir --upgrade pip \
  && pip3 install --no-cache-dir --upgrade wheel yamllint jsonlint dos2unix ansible ansible-lint \
  && rm -rf /root/.cache ||true \
  && mkdir -p ~/.ssh \
  && eval "$(ssh-agent -s)" \
  && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config \
  && chmod -R 700 ~/.ssh
RUN ansible-galaxy install -r /tmp/requirements.yml -p /usr/share/ansible/collections
CMD ["busybox"]

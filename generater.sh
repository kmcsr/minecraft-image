#!/bin/sh

BASE_DIR=$(dirname $0)

DOCKERFILE_SUFFIX=.tmp.Dockerfile
echo 'Generating Dockerfile suffix:' "${DOCKERFILE_SUFFIX}"

[ -n "$DEFAULT_JAVA" ] || DEFAULT_JAVA=17

[ -n "$PYTHON_VERSION" ] || PYTHON_VERSION=3.10

if ! [ -n "$NO_MCDR" ]; then
  [ -n "$MCDR_VERSION" ] || { echo 'FAULT: You must set the mcdreforged version at `MCDR_VERSION`'; exit 2; }
  echo 'Generating mcdr version:' "v${MCDR_VERSION}"
fi

[ -n "${JAVA_VERSIONS[*]}" ] || JAVA_VERSIONS=(8 11 17)
echo 'Generating Java versions:' "${JAVA_VERSIONS[*]}"

function gen_vanilla(){
	_JAVA=$1
	[ -n "$_JAVA" ] || _JAVA=$DEFAULT_JAVA
  _FILE="java${_JAVA}${DOCKERFILE_SUFFIX}"
  echo ">>> generating ${_FILE}"
	cat >"$_FILE" <<EOF
# syntax=docker/dockerfile:1

FROM craftmine/server-installer:latest AS server_installer

FROM alpine:latest

RUN apk add --no-cache openjdk${_JAVA}-jre && \\
  java -version

WORKDIR /minecraft

COPY --from=server_installer /usr/local/bin/minecraft_installer /usr/local/bin/minecraft_installer
COPY ${BASE_DIR}/entry_point.sh /root/entry_point.sh
COPY ${BASE_DIR}/init_vanilla.sh /root/init.sh

ENV COMMAND=(/usr/bin/env java -jar)
ENV ARGS=minecraft.jar

STOPSIGNAL SIGINT

ENTRYPOINT ["/root/entry_point.sh", "/root/init.sh"]
CMD []
EOF
}

function gen_mcdr(){
	_JAVA=$1
	[ -n "$_JAVA" ] || _JAVA=$DEFAULT_JAVA
  _FILE="java${_JAVA}-mcdr${MCDR_VERSION}${DOCKERFILE_SUFFIX}"
  echo ">>> generating ${_FILE}"
	cat >"$_FILE" <<EOF
# syntax=docker/dockerfile:1

FROM craftmine/server-installer:latest AS server_installer

FROM python:${PYTHON_VERSION}-alpine

RUN apk add --no-cache --virtual .install-deps \\
    gcc \\
    gdbm-dev \\
    libc-dev \\
    libffi-dev \\
    libnsl-dev \\
    libtirpc-dev \\
    linux-headers \\
    make \\
  && \\
  pip3 install 'mcdreforged~=${MCDR_VERSION}' && \\
  python3 --version && \\
  apk del --no-network .install-deps;

RUN apk add --no-cache openjdk${_JAVA}-jre && \\
  java -version

WORKDIR /minecraft

COPY --from=server_installer /usr/local/bin/minecraft_installer /usr/local/bin/minecraft_installer
COPY ${BASE_DIR}/entry_point.sh /root/entry_point.sh
COPY ${BASE_DIR}/init_mcdr.sh /root/init.sh

ENV COMMAND=(/usr/bin/env python3 -m mcdreforged)
ENV ARGS=

STOPSIGNAL SIGINT

ENTRYPOINT ["/root/entry_point.sh", "/root/init.sh"]
CMD []
EOF
}

function generate(){
  gen_vanilla "$@"
  if ! [ -n "$NO_MCDR" ]; then
    gen_mcdr "$@"
  fi
}

echo
echo '==> Clearing old tmp dockerfiles'
rm *"${DOCKERFILE_SUFFIX}"
echo

for j in ${JAVA_VERSIONS[@]}; do
  generate $j
done

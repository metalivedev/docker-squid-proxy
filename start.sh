#!/bin/sh
set -e


DIR_UID=31
DIR_GID=31
CACHE_DIR=/var/cache/squid/
LOG_DIR=/var/log/squid/

[ -d "${CACHE_DIR}" ] || mkdir -p "${CACHE_DIR}"
[ "${DIR_UID}:${DIR_GID}" = `stat -c %u:%g "${CACHE_DIR}"` ] || chown ${DIR_UID}:${DIR_GID} "${CACHE_DIR}"

[ -d "${LOG_DIR}" ] || mkdir -p "${LOG_DIR}"
[ "${DIR_UID}:${DIR_GID}" = `stat -c %u:%g "${LOG_DIR}"` ] || chown ${DIR_UID}:${DIR_GID} "${LOG_DIR}"

docker run \
    --name squid-proxy \
    --rm \
    --read-only \
    --net=host \
    --cap-drop ALL \
    --cap-add SETUID \
    --cap-add SETGID \
    --cap-add NET_ADMIN \
    --cap-add NET_RAW \
    --cap-add KILL \
    -v "${CACHE_DIR}":/var/cache/squid \
    -v "${LOG_DIR}":/var/log/squid \
    piotrminkina/squid-proxy

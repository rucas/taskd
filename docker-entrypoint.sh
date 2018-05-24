#!/bin/sh
set -e
PKI=$TASKDDATA/pki

if [ ! -d "$PKI" ]; then
    mkdir -p "$PKI"
    cp /usr/share/taskd/pki/* "$PKI"
    taskd init > /dev/null 2>&1
fi

if [ ! -f "$PKI/ca.cert.pem" ]; then
    cd "$PKI"
    sed -i "s/\\(CN=\\).*/\\1${CERT_CN:-localhost}/" vars
    sed -i "s/\\(ORGANIZATION=\\).*/\\1\"${CERT_ORGANIZATION:-"Göteborg Bit Factory"}\"/" vars
    sed -i "s/\\(COUNTRY=\\).*/\\1${CERT_COUNTRY:-SE}/" vars
    sed -i "s/\\(STATE=\\).*/\\1\"${CERT_STATE:-"Västra Götaland"}\"/" vars
    sed -i "s/\\(LOCALITY=\\).*/\\1\"${CERT_LOCALITY:-"Göteborg"}\"/" vars

    ./generate
    taskd config --force client.cert "$PKI/client.cert.pem"
    taskd config --force client.key "$PKI/client.key.pem"
    taskd config --force server.cert "$PKI/server.cert.pem"
    taskd config --force server.key "$PKI/server.key.pem"
    taskd config --force server.crl "$PKI/server.crl.pem"
    taskd config --force ca.cert "$PKI/ca.cert.pem"
    taskd config --force log "$TASKDDATA/taskd.log"
    taskd config --force pid.file "$TASKDDATA/taskd.pid"
    taskd config --force server 0.0.0.0:53589

    taskd add org "${ORG:=Public}"
    taskd add user "${ORG}" "${FIRST_NAME:=Rucas} ${LAST_NAME:=Mania}"
    ./generate.client "${FIRST_NAME}_${LAST_NAME}"
    chown -R taskd:taskd "$TASKDDATA"
fi

if [ "$1" = 'taskd' ] && [ "$(id -u)" = '0' ]; then
    chown -R taskd:taskd "$TASKDDATA"
    set -- gosu taskd "$@"
fi

exec "$@"

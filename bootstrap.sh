#!/bin/bash

client() {
    if [ -z "$HOST" ]; then
        echo
        echo "Missing Host..."
        exit 1
    fi
    if [ -z "$ID" ]; then
        echo
        echo "Missing ID..."
        exit 1
    fi
    if [ -z "$FIRST_NAME" ]; then
        echo
        echo "Missing First Name..."
        exit 1
    fi
    if [ -z "$LAST_NAME" ]; then
        echo
        echo "Missing Last Name"
        exit 1
    fi

    echo "Setting up taskwarrrior client..."
    cp "$CA" "$CERT" "$KEY" ~/.task
    yes | task config taskd.certificate "$CERT" > /dev/null 2>&1
    yes | task config taskd.key "$KEY" > /dev/null 2>&1
    yes | task config taskd.ca  "$CA" > /dev/null 2>&1
    yes | task config taskd.server "$HOST" > /dev/null 2>&1   
    yes | task config taskd.credentials "Public/${FIRST_NAME} ${LAST_NAME}/${ID}" > /dev/null 2>&1
}

clean() {
    echo "cleaning up..."
    rm -rf taskd/
    rm -rf "$HOME/.task/$(basename "$CA")"
    rm -rf "$HOME/.task/$(basename "$CERT")" 
    rm -rf "$HOME/.task/$(basename "$KEY")" 
}

help() {
    echo 
    echo "you want help...?" 
    echo 
    echo "you dont need any help."
}

# Main
#
# 

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c|--ca)
    CA="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--host)
    HOST="$2"
    shift # past argument
    shift # past value
    ;;
    -f|--firstname)
    FIRST_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--lastname)
    LAST_NAME="$2"
    shift # past argument
    shift # past value
    ;;
    -i|--id)
    ID="$2"
    shift # past argument
    shift # past value
    ;;
    -r|--cert)
    CERT="$2"
    shift # past argument
    shift # past value
    ;;
    -k|--key)
    KEY="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--debug)
    DEBUG=true
    shift # past value
    ;;
    --help)
    help
    exit 0
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ ${DEBUG} ]]; then
    echo 
    echo
    echo CA         = "${CA}"
    echo CERT       = "${CERT}"
    echo KEY        = "${KEY}"
    echo ID         = "${ID}"
    echo HOST       = "${HOST}"
    echo FIRST_NAME = "${FIRST_NAME}" 
    echo LAST_NAME  = "${LAST_NAME}" 
    echo 
    echo 
fi

# All params set
if [ -n "$CA" ] && [ -n "$CERT" ] && [ -n "$KEY" ]; then
    "$@"
else
    help
fi

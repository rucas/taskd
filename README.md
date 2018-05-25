<h1 align="center">taskd</h1>

> A containerized taskwarrior server

## Install

```sh
$ docker pull rucas/taskd
```

## Usage

### Start a Taskwarrior Server

```sh
$ docker run -d -p 53589:53589 \
    -v $PWD/taskd:/var/taskd \
    -e FIRST_NAME=rucas \
    -e LAST_NAME=mania \
    -e ORG=Public \
    -e CERT_CN=localhost \
    -e CERT_ORGANIZATION=rucas \
    -e CERT_COUNTRY=US \
    -e CERT_STATE=Oregon \
    -e CERT_LOCALITY=Portland
```

### Sync with Taskwarrior Client

```sh
$ ./bootstrap.sh \
    --ca taskd/pki/ca.cert.pem \
    --key taskd/pki/rucas_mania.key.pem \
    --cert taskd/pki/rucas_mania.cert.pem \
    --host localhost:53589 \
    --id 07830604-cd85-4381-9547-0ee9f127c823 \
    --firstname rucas \
    --lastname mania \
    client
```

## Contributing

:wave: :point_right: Check out the [Contributing](CONTRIBUTING.md) doc to get you 
started.

## FAQ

### Who?

Checkout the [Maintainers](MAINTAINERS.md) doc to see who has contributed.

### What is Taskwarrior?

### When?

### What is bootstrap.sh?

### Why?

## License

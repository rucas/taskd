# Contributing

Thank you for your contribution. Here are a set of guidelines for contributing to the taskd project.

Just follow these simple guidelines to get your PR merged ASAP.

## Installing

```sh
$ git clone https://github.com/rucas/taskd 
```

## Tests

### official-images

In order to run tests you need to clone:

```sh
$ git clone https://github.com/docker-library/official-images
$ ./official-images/test/run.sh rucas/taskd
```

### shellcheck

```sh
$ brew install shellcheck
$ shellcheck *.sh
```

### hadolint

```sh
$ brew install hadolint
$ hadolint Dockerfile
```

## Submitting a Patch

1. Create an [issue](https://github.com/rucas/taskd/issues/new)
2. Fork the repo
3. Run tests
4. Push commits to your fork and submit a PR

# nfrastack/authentik:outpost

## About

Outpost only image for [authentik](https://goauthentik.io).

Included outposts:

- `proxy`
- `ldap`
- `radius`
- `rac`

## Maintainer

- [Nfrastack](https://www.nfrastack.com)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Prebuilt Images](#prebuilt-images)
  - [Quick Start](#quick-start)
  - [Building](#building)
- [Environment Variables](#environment-variables)
- [Users and Groups](#users-and-groups)
- [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support & Maintenance](#support--maintenance)
- [References](#references)
- [License](#license)

## Installation

### Prebuilt Images

Prebuilt images are available on the [Github Container Registry](https://github.com/nfrastack/container-authentik/pkgs/container/container-authentik) and [Docker Hub](https://hub.docker.com/r/nfrastack/authentik).

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-authentik:(image_tag)
docker.io/nfrastack/authentik:(image_tag)
```

Outpost tags:

* `outpost` will be the most recent commit
* An optional `tag` may exist that matches the [CHANGELOG](../CHANGELOG.md) with an `-outpost` suffix (e.g. `1.0-outpost`) - These are the safest

Have a look at the container registries and see what tags are available.

### Quick Start

Compose examples live in [`examples/compose-outpost.yml`](../examples/compose-outpost.yml).

One or more outposts run per container, selected with `OUTPOST_TYPE` (comma separated for several eg ldap, proxy, NOT multiple of same type!)

Each type needs the token of its own outpost object in authentik (`AUTHENTIK_TOKEN_<TYPE>`, falling back to `AUTHENTIK_TOKEN`).
Each type serves metrics on its own port (`9300` proxy, `9301` ldap, `9302` radius, `9303` rac).

Set a stable `--hostname`. Authentik tracks outpost instances by hostname and never removes dead ones, so a new random hostname on every restart piles up stale
instance rows in the backend that only disappear when deleted by hand.

Logs are written under `/logs/outpost/` (`LOG_TYPE=both` by default).

### Building

Use the repo Makefile:

```
make outpost            # builder + full outpost image
make outpost-slim       # without RAC/guacd
```

## Environment Variables

Below is the complete list of available options that can be used to customize your installation.


| Variable                    | Description                                              | Default               | `_FILE` |
| --------------------------- | -------------------------------------------------------- | --------------------- | ------- |
| `OUTPOST_TYPE`              | `proxy`, `ldap`, `radius`, `rac`, comma separated        | `proxy`               |         |
| `LOG_LEVEL`                 | Log level                                                | `info`                |         |
| `LOG_TYPE`                  | Type `console` `file` `both`                             | `file`                |         |
| `LOG_PATH`                  | Log Path                                                 | `/logs/`              |         |
| `AUTHENTIK_HOST`            | Fallback URL of the authentik server (required)          |                       |         |
| `AUTHENTIK_HOST_PROXY`      | URL of the authentik server for the proxy outpost        | ${AUTHENTIK_HOST}     |         |
| `AUTHENTIK_HOST_LDAP`       | URL of the authentik server for the ldap outpost         | ${AUTHENTIK_HOST}     |         |
| `AUTHENTIK_HOST_RADIUS`     | URL of the authentik server for the radius outpost       | ${AUTHENTIK_HOST}     |         |
| `AUTHENTIK_HOST_RAC`        | URL of the authentik server for the rac outpost          | ${AUTHENTIK_HOST}     |         |
| `AUTHENTIK_TOKEN`           | Fallback token for all enabled types                     |                       | x       |
| `AUTHENTIK_INSECURE`        | Skip TLS verification to the server                      | `FALSE`               |         |
| `AUTHENTIK_INSECURE_PROXY`  | Skip TLS verification for the proxy outpost              | ${AUTHENTIK_INSECURE} |         |
| `AUTHENTIK_INSECURE_LDAP`   | Skip TLS verification for the ldap outpost               | ${AUTHENTIK_INSECURE} |         |
| `AUTHENTIK_INSECURE_RADIUS` | Skip TLS verification for the radius outpost             | ${AUTHENTIK_INSECURE} |         |
| `AUTHENTIK_INSECURE_RAC`    | Skip TLS verification for the rac outpost                | ${AUTHENTIK_INSECURE} |         |
| `AUTHENTIK_HOST_BROWSER`    | Browser-reachable authentik URL for login redirects when |                       |         |
|                             | it differs from AUTHENTIK_HOST                           |                       |         |
| `PROXY_LOG_FILE`            | Proxy log file name                                      | `proxy.log`           |         |
| `PROXY_LOG_PATH`            | Proxy log directory                                      | ${LOG_PATH}           |         |
| `PROXY_LOG_TYPE`            | Proxy log destination                                    | ${LOG_TYPE}           |         |
| `LDAP_LOG_FILE`             | LDAP log file name                                       | `ldap.log`            |         |
| `LDAP_LOG_PATH`             | LDAP log directory                                       | ${LOG_PATH}           |         |
| `LDAP_LOG_TYPE`             | LDAP log destination                                     | ${LOG_TYPE}           |         |
| `RADIUS_LOG_FILE`           | RADIUS log file name                                     | `radius.log`          |         |
| `RADIUS_LOG_PATH`           | RADIUS log directory                                     | ${LOG_PATH}           |         |
| `RADIUS_LOG_TYPE`           | RADIUS log destination                                   | ${LOG_TYPE}           |         |
| `RAC_LOG_FILE`              | RAC log file name                                        | `rac.log`             |         |
| `RAC_LOG_PATH`              | RAC log directory                                        | ${LOG_PATH}           |         |
| `RAC_LOG_TYPE`              | RAC log destination                                      | ${LOG_TYPE}           |         |
| `GUACD_LOG_FILE`            | guacd log file name                                      | `guacd.log`           |         |
| `GUACD_LOG_PATH`            | guacd log directory                                      | ${LOG_PATH}           |         |
| `GUACD_LOG_TYPE`            | guacd log destination                                    | ${LOG_TYPE}           |         |
| `AUTHENTIK_TOKEN_PROXY`     | Token of the proxy outpost object                        | ${AUTHENTIK_TOKEN}    | x       |
| `PROXY_METRICS_PORT`        | Proxy outpost metrics port                               | `9300`                |         |
| `AUTHENTIK_TOKEN_LDAP`      | Token of the ldap outpost object                         | ${AUTHENTIK_TOKEN}    | x       |
| `LDAP_METRICS_PORT`         | LDAP outpost metrics port                                | `9301`                |         |
| `AUTHENTIK_TOKEN_RADIUS`    | Token of the radius outpost object                       | ${AUTHENTIK_TOKEN}    | x       |
| `RADIUS_METRICS_PORT`       | RADIUS outpost metrics port                              | `9302`                |         |
| `AUTHENTIK_TOKEN_RAC`       | Token of the rac outpost object                          | ${AUTHENTIK_TOKEN}    | x       |
| `RAC_METRICS_PORT`          | RAC outpost metrics port                                 | `9303`                |         |
| `GUACD_HOST`                | External guacd host when not bundled                     | `127.0.0.1`           |         |
| `GUACD_PORT`                | External guacd when not bundled                          | `4822`                |         |

Any other authentik setting from the [configuration reference](https://docs.goauthentik.io/docs/install-config/configuration/) can be passed through as `AUTHENTIK_<SECTION>__<KEY>`
(eg `AUTHENTIK_LISTEN__HTTP`).

## Users and Groups

| Type  | Name        | ID     |
| ----- | ----------- | ------ |
| User  | `authentik` | `1000` |
| Group | `authentik` | `1000` |

### Networking

| Port   | Protocol | Description    |
| ------ | -------- | -------------- |
| `1812` | `udp`    | Radius         |
| `3389` | `tcp`    | LDAP           |
| `4822` | `tcp`    | guacd          |
| `6636` | `tcp`    | LDAP TLS       |
| `9000` | `tcp`    | Proxy / RAC    |
| `9300` | `tcp`    | Proxy metrics  |
| `9301` | `tcp`    | LDAP metrics   |
| `9302` | `tcp`    | RADIUS metrics |
| `9303` | `tcp`    | RAC metrics    |
| `9443` | `tcp`    | Proxy TLS      |

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

Useful paths inside the image:

| Path                              | Description                         |
| --------------------------------- | ----------------------------------- |
| `/usr/local/bin/authentik`        | Proxy outpost binary (`--help`)     |
| `/usr/local/bin/authentik-ldap`   | LDAP outpost binary                 |
| `/usr/local/bin/authentik-radius` | RADIUS outpost binary               |
| `/usr/local/bin/authentik-rac`    | RAC outpost binary                  |
| `/usr/sbin/guacd`                 | Bundled Guacamole daemon (RAC only) |

## Support & Maintenance

- For community help, tips, and community discussions, visit the [Discussions board](/discussions).
- For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
- To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
- Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
- Updates are best-effort, with priority given to active production use and support agreements.

## References

* <https://goauthentik.io>
* [Server image documentation](../README.md)

## License

MIT - see [LICENSE](../LICENSE).

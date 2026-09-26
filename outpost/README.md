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

One outpost runs per container, selected with `OUTPOST_TYPE`:

```
docker run -e OUTPOST_TYPE=ldap \
  -e AUTHENTIK_HOST=https://auth.example.com \
  -e AUTHENTIK_TOKEN=<token-from-Applications->-Outposts> \
  -p 3389:3389 -p 6636:6636 \
  nfrastack/authentik:outpost
```

No persistent storage is required. Logs are written under `/logs/outpost/` (`LOG_TYPE=both` by default).

### Building

Use the repo Makefile:

```
make outpost            # builder + full outpost image
make outpost-slim       # without RAC/guacd
```

## Environment Variables

Below is the complete list of available options that can be used to customize your installation.

* Variables showing a value under the `_FILE` column can also be supplied via `<VARIABLE>_FILE` pointing at a file (e.g. docker secrets); see the base image documentation.

| Variable                 | Description                                                | Default          | `_FILE` |
| ------------------------ | ---------------------------------------------------------- | ---------------- | ------- |
| `OUTPOST_TYPE`           | `proxy`, `ldap`, `radius` or `rac`                         | `proxy`          |         |
| `LOG_LEVEL`              | Log level                                                  | `info`           |         |
| `LOG_TYPE`               | `console` `file` `both`                                    | `file`           |         |
| `LOG_PATH`               | Log Path                                                   | `/logs/`         |         |
| `AUTHENTIK_HOST`         | URL of the authentik server (required)                     |                  |         |
| `AUTHENTIK_TOKEN`        | Outpost token from authentik (required, `_FILE` supported) |                  | x       |
| `AUTHENTIK_INSECURE`     | Skip TLS verification to the server                        | `FALSE`          |         |
| `AUTHENTIK_HOST_BROWSER` | Public URL for user-facing interactions (proxy)            |                  |         |
| `GUACD_HOST`             | External guacd host when not bundled                       | `127.0.0.1`      |         |
| `GUACD_PORT`             | External guacd when not bundled                            | `4822`           |         |

Any other authentik setting from the [configuration reference](https://docs.goauthentik.io/docs/install-config/configuration/) can be passed through as `AUTHENTIK_<SECTION>__<KEY>`
(eg `AUTHENTIK_LISTEN__HTTP`).

## Users and Groups

| Type  | Name        | ID     |
| ----- | ----------- | ------ |
| User  | `authentik` | `1000` |
| Group | `authentik` | `1000` |

### Networking

| Port   | Protocol | Description  |
| ------ | -------- | ------------ |
| `1812` | `udp`    | Radius       |
| `3389` | `tcp`    | LDAP         |
| `4822` | `tcp`    | guacd        |
| `6636` | `tcp`    | LDAP TLS     |
| `9000` | `tcp`    | Proxy / RAC  |
| `9300` | `tcp`    | Metrics      |
| `9443` | `tcp`    | Proxy TLS    |

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

Useful paths inside the image:

| Path                                | Description                              |
| ----------------------------------- | ---------------------------------------- |
| `/usr/local/bin/authentik`          | Proxy outpost binary (`--help`)          |
| `/usr/local/bin/authentik-ldap`     | LDAP outpost binary                      |
| `/usr/local/bin/authentik-radius`   | RADIUS outpost binary                    |
| `/usr/local/bin/authentik-rac`      | RAC outpost binary                       |
| `/usr/sbin/guacd`                   | Bundled Guacamole daemon (RAC only)      |

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

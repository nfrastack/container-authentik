# nfrastack/container-authentik

## About

This repository will build a container for [authentik](https://goauthentik.io), an identity provider.

- Two images
  - AIO: Server, Worker, WebUI, Proxy Outpost
  - Outposts: LDAP, Proxy, Radius, RAC

## Maintainer

- [Nfrastack](https://www.nfrastack.com)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Prebuilt Images](#prebuilt-images)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
- [Environment Variables](#environment-variables)
  - [Base Images used](#base-images-used)
  - [Authentik General Options](#authentik-general-options)
  - [Authentik Proxy Outpost Options](#authentik-proxy-outpost-options)
  - [Database Options](#database-options)
- [Users and Groups](#users-and-groups)
- [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support & Maintenance](#support--maintenance)
- [References](#references)
- [License](#license)

## Installation

### Prebuilt Images

Builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-authentik/pkgs/container/container-authentik) and [Docker Hub](https://hub.docker.com/r/nfrastack/authentik).

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-authentik:(image_tag)
docker.io/nfrastack/authentik:(image_tag)
```

Image tag syntax is:

`<image>:<optional tag>`

### Image Variants

Two images share this repository

| Tag(s)                          | Image   | Description                                 |
| ------------------------------- | ------- | ------------------------------------------- |
| `latest`, `<version>`, `server` | Server  | Server + worker + embedded proxy            |
| `outpost`, `<version>-outpost`  | Outpost | Proxy/LDAP/RADIUS/RAC outposts only + guacd |

* `latest` defaults to the server image.
* `<version>` matches the [CHANGELOG](CHANGELOG.md)
* Pull the outpost variant with e.g. `docker.io/nfrastack/authentik:outpost`.

Outpost docs are available in [outpost/README.md](outpost/README.md).

Example:

`ghcr.io/nfrastack/container-authentik:latest` or

`ghcr.io/nfrastack/container-authentik:1.0` or

* `latest` will be the most recent commit
* An optional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md)
* Append `-outpost` (e.g. `1.0-outpost`) or use `outpost` for the latest outposts only image

Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/).  See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

* Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
* Set various [environment variables](#environment-variables) to understand the capabilities of this image.


## Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory     | Description                                         |
| ------------- | --------------------------------------------------- |
| `/certs/`     | Certificates                                        |
| `/data/`      | Managed file storage (`media/` uploads, `reports/`) |
| `/media/`     | User uploaded media                                 |
| `/templates/` | Custom templates                                    |

## Environment Variables

### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                   | Description           |
| ------------------------------------------------------- | --------------------- |
| [OS Base](https://github.com/nfrastack/container-base/) | Base Image            |
| [Nginx](https://github.com/nfrastack/container-nginx/)  | Web Server Base Image |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing a value under the `_FILE` column can also be supplied via `<VARIABLE>_FILE` pointing at a file (e.g. docker secrets); see the base image documentation.
* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

### Container Options

| Parameter         | Description             | Default        | _FILE |
| ----------------- | ----------------------- | -------------- | ----- |
| `AUTHENTIK_USER`  | User authentik runs as  | `authentik`    |       |
| `AUTHENTIK_GROUP` | Group authentik runs as | `authentik`    |       |
| `DATA_PATH`       | Local file storage      | `/data/`       |       |
| `CERTS_PATH`      | Certificates            | `/certs/`      |       |
| `BLUEPRINTS_PATH` | Blueprints              | `/blueprints/` |       |
| `TEMPLATE_PATH`   | Custom Templates        | `/templates/`  |       |



### Authentik General Options

| Parameter                  | Description                                                       | Default                         | _FILE |
| -------------------------- | ----------------------------------------------------------------- | ------------------------------- | ----- |
| `AUTHENTIK_MODE`           | `SERVER` `WORKER` `PROXY` comma seperated                         | `server,worker`                 |       |
| `AUTHENTIK_SECRET_KEY`     | Secret key for cryptographic signing (required for server/worker) |                                 |       |
| `LISTEN_PORT`              | HTTP port the server listens on                                   | `9000`                          |       |
| `PROMETHEUS_MULTIPROC_DIR` | Directory for prometheus multiprocess metrics                     | `/tmp/authentik_prometheus_tmp` |       |
| `LOG_LEVEL`                | Log level                                                         | `info`                          |       |
| `LOG_TYPE`                 | Log destination: `console`, `file`, or `both`                     | `file`                          |       |
| `LOG_PATH`                 | Default log file directory (`file`/`both` modes)                  | `/logs/authentik/`              |       |
| `PROXY_LOG_FILE`           | Proxy log file name                                               | `proxy.log`                     |       |
| `PROXY_LOG_LEVEL`          | Proxy log level                                                   | ${LOG_LEVEL}                    |       |
| `PROXY_LOG_PATH`           | Proxy log directory                                               | ${LOG_PATH}                     |       |
| `PROXY_LOG_TYPE`           | Proxy log destination                                             | ${LOG_TYPE}                     |       |
| `SERVER_LOG_FILE`          | Server log file name                                              | `server.log`                    |       |
| `SERVER_LOG_LEVEL`         | Server log level                                                  | ${LOG_LEVEL}                    |       |
| `SERVER_LOG_PATH`          | Server log directory                                              | ${LOG_PATH}                     |       |
| `SERVER_LOG_TYPE`          | Server log destination                                            | ${LOG_TYPE}                     |       |
| `WORKER_LOG_FILE`          | Worker log file name                                              | `worker.log`                    |       |
| `WORKER_LOG_LEVEL`         | Worker log level                                                  | ${LOG_LEVEL}                    |       |
| `WORKER_LOG_PATH`          | Worker log directory                                              | ${LOG_PATH}                     |       |
| `WORKER_LOG_TYPE`          | Worker log destination                                            | ${LOG_TYPE}                     |       |

### Database Options

| Parameter | Description                                      | Default      | _FILE |
| --------- | ------------------------------------------------ | ------------ | ----- |
| `DB_HOST` | PostgreSQL hostname                              | `postgresql` | x     |
| `DB_PORT` | PostgreSQL port                                  | `5432`       | x     |
| `DB_NAME` | PostgreSQL database name                         |              | x     |
| `DB_USER` | PostgreSQL username                              |              | x     |
| `DB_PASS` | PostgreSQL password (required for server/worker) |              | x     |

### Outpost Proxy Outpost Options

Enable with `AUTHENTIK_MODE=server,worker,proxy` (or `proxy` alone against a remote server).

| Parameter            | Description                                      | Default                   | _FILE |
| -------------------- | ------------------------------------------------ | ------------------------- | ----- |
| `AUTHENTIK_HOST`     | URL of the authentik server                      | `http://localhost:9000` * |       |
| `AUTHENTIK_TOKEN`    | Outpost token from authentik                     |                           |       |
| `AUTHENTIK_INSECURE` | Skip TLS verification when talking to the server | `FALSE`                   |       |

\* Only defaulted when `server` is also selected; otherwise `AUTHENTIK_HOST` is required.

>> When the proxy runs alongside the server in the same container, its listen ports are remapped automatically to dodge the server's ports (`:9001`/`:9444`/`:9301` instead of `:9000`/>> `:9443`/`:9300`). Running `proxy` alone keeps the standard ports.

Any other authentik setting from the [configuration reference](https://docs.goauthentik.io/docs/install-config/configuration/) can be passed through as `AUTHENTIK_<SECTION>__<KEY>` (eg `AUTHENTIK_LISTEN__HTTP`).

## Users and Groups

| Type  | Name        | ID     |
| ----- | ----------- | ------ |
| User  | `authentik` | `1000` |
| Group | `authentik` | `1000` |

### Networking

| Port   | Protocol | Description                                  |
| ------ | -------- | -------------------------------------------- |
| `80`   | `tcp`    | Nginx                                        |
| `9000` | `tcp`    | Authentik server HTTP                        |
| `9443` | `tcp`    | Authentik server HTTPS                       |
| `9300` | `tcp`    | Server metrics                               |
| `9005` | `tcp`    | Worker healthcheck (localhost only)          |
| `9301` | `tcp`    | Worker metrics                               |
| `9001` | `tcp`    | Proxy outpost HTTP (only when co-located)    |
| `9444` | `tcp`    | Proxy outpost HTTPS (only when co-located)   |
| `9302` | `tcp`    | Proxy outpost metrics (only when co-located) |

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

Useful paths inside the image:

| Path                       | Description                           |
| -------------------------- | ------------------------------------- |
| `/usr/local/bin/authentik` | Server/worker/proxy binary (`--help`) |
| `/usr/local/bin/ak`        | Lifecycle dispatcher (`eg ak server`) |
| `/usr/share/authentik`     | Application source tree               |
| `/opt/authentik`           | Python virtual environment            |
| `/web/dist`                | Built web UI                          |

## Support & Maintenance

- For community help, tips, and community discussions, visit the [Discussions board](/discussions).
- For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
- To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
- Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
- Updates are best-effort, with priority given to active production use and support agreements.

## References

* <https://goauthentik.io>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

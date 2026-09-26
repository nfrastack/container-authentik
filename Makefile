# SPDX-FileCopyrightText: © 2026 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

# Ordered local builds for container-authentik.
#
#   make builder          shared throwaway builder (toolchain + all compiles)
#   make server           authentik server/worker image (need builder first)
#   make outpost          outpost image, all types + guacd (need builder first)
#   make outpost-slim     outpost image without RAC/guacd
#   make all              builder + server + outpost
#   make clean            remove local images
#   make clean-builder    remove ONLY the builder
#
# Everything is parameterized
#   make outpost BUILD_RAC=FALSE BUILD_GUACD=FALSE
#   make all BASE_IMAGE=docker.io/nfrastack/base:alpine_3.24 AUTHENTIK_VERSION=version/2026.8.3

export DOCKER_BUILDKIT=0

BASE_IMAGE       ?= docker.io/nfrastack/base:alpine_3.24
BUILDER_TAG      ?= nfrastack/authentik-builder:local
SERVER_TAG       ?= nfrastack/authentik:local
OUTPOST_TAG      ?= nfrastack/authentik-outpost:local
AUTHENTIK_VERSION ?= version/2026.8.3
PYTHON_VERSION   ?= 3.14
PNPM_VERSION     ?= 12.4.0

BUILD_PROXY      ?= TRUE
BUILD_LDAP       ?= TRUE
BUILD_RADIUS     ?= TRUE
BUILD_RAC        ?= TRUE
BUILD_GUACD      ?= TRUE

.PHONY: help builder server outpost outpost-slim all clean clean-builder

help:
	@echo "Targets: builder server outpost outpost-slim all clean clean-builder"
	@echo "Vars: BASE_IMAGE BUILDER_TAG SERVER_TAG OUTPOST_TAG AUTHENTIK_VERSION"
	@echo "      PYTHON_VERSION PNPM_VERSION BUILD_PROXY/LDAP/RADIUS/RAC/GUACD"

builder:
	docker build \
		--pull \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg AUTHENTIK_VERSION=$(AUTHENTIK_VERSION) \
		--build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
		--build-arg PNPM_VERSION=$(PNPM_VERSION) \
		-t $(BUILDER_TAG) \
		-f builder/Containerfile .

server: builder
	docker build \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		-t $(SERVER_TAG) \
		-f server/Containerfile .

outpost: builder
	docker build \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg BUILD_PROXY=$(BUILD_PROXY) \
		--build-arg BUILD_LDAP=$(BUILD_LDAP) \
		--build-arg BUILD_RADIUS=$(BUILD_RADIUS) \
		--build-arg BUILD_RAC=$(BUILD_RAC) \
		--build-arg BUILD_GUACD=$(BUILD_GUACD) \
		-t $(OUTPOST_TAG) \
		-f outpost/Containerfile .

outpost-slim: builder
	$(MAKE) outpost BUILD_RAC=FALSE BUILD_GUACD=FALSE

all: builder server outpost

clean:
	-docker rmi $(SERVER_TAG) $(OUTPOST_TAG) $(BUILDER_TAG)

clean-builder:
	-docker rmi $(BUILDER_TAG)

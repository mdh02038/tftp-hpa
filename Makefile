
.PHONY: default build auto-build-and-push build-and-push-builder build-builder


PLATFORMS ?= linux/amd64,linux/arm64
DOCKER_IMAGE ?= raquette/tftp-hpa-builder
BUILDER_PLATFORMS ?= linux/amd64
BUILDER_DOCKER_IMAGE ?= raquette/tftp-hpa-builder
VERSION ?= "edge"

MANIFEST_TAG = $(DOCKER_IMAGE):$(VERSION)
BUILDER_MANIFEST_TAG = $(BUILDER_DOCKER_IMAGE):$(VERSION)

default: build

auto-build-and-push: syslinux.tar
	docker buildx build  --push --platform $(PLATFORMS) -t "$(MANIFEST_TAG)"  --build-arg VERSION=${VERSION} -f Dockerfile . 

build: syslinux.tar
	docker buildx build --platform $(PLATFORMS) -t "$(MANIFEST_TAG)"  --build-arg VERSION=${VERSION} -f Dockerfile . 

auto-build-and-push-builder:
	docker buildx build  --push --platform $(BUILDER_PLATFORMS) -t "$(BUILDER_MANIFEST_TAG)"  --build-arg VERSION=${VERSION} -f Dockerfile.builder . 

build-builder:
	docker buildx build --platform $(BUILDER_PLATFORMS) -t "$(BUILDER_MANIFEST_TAG)"  --build-arg VERSION=${VERSION} -f Dockerfile.builder . 

syslinux.tar: build-builder
	docker run raquette/tftp-hpa-builder > syslinux.tar

CONTAINER_ENGINE=podman
T="ghcr.io/amp-rh/rendercv:latest"

default: build

build:
	$$CONTAINER_ENGINE build -t $T  .

run: build
	$$CONTAINER_ENGINE run --rm $T

debug: build
	$$CONTAINER_ENGINE run -it --entrypoint=bash --rm $T

push: build
	$$CONTAINER_ENGINE push $T

#!/usr/bin/env bash

set -eu

export HOST_WORKSPACE=${1:-$PWD}
export CONTAINER_WORKSPACE=/home/devuser/workspace

USER_ID=$(id -u)
export USER_ID
GROUP_ID=$(id -g)
export GROUP_ID

export OPAM_VERSION=2.0.6
export OCAML_VERSION=4.07.1
export Z3_URL=https://github.com/sofia-rose/binaries/raw/master/z3-tested/z3-4.8.5-x64-debian-8.11.zip
export FSTAR_SHA=2844d507fd99ab5675cf0dff8343040fed9d319a
export KREMLIN_SHA=04054342cb527ecb97633d0d88a739ae0b320146
export VALE_VERSION=0.3.12

export IMAGE_REPO="sofiarose/containerized-fstar"
export IMAGE_TAG="${FSTAR_SHA}"

docker build \
  --build-arg OPAM_VERSION=${OPAM_VERSION} \
  --build-arg OCAML_VERSION=${OCAML_VERSION} \
  --build-arg FSTAR_SHA=${FSTAR_SHA} \
  --build-arg KREMLIN_SHA=${KREMLIN_SHA} \
  --build-arg VALE_VERSION=${VALE_VERSION} \
  --build-arg Z3_URL=${Z3_URL} \
  --build-arg "USER_ID=${USER_ID}"  \
  --build-arg "GROUP_ID=${GROUP_ID}" \
  --tag "${IMAGE_REPO}:${IMAGE_TAG}" \
  .

docker push "${IMAGE_REPO}:${IMAGE_TAG}"

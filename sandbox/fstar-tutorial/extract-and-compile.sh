#!/usr/bin/env bash

set -eux

FILE=$1

NAME="${FILE%.fst}"

OCAML_EXTRACT_DIR="${NAME}-extracted"

fstar \
  --codegen OCaml \
  --odir "${OCAML_EXTRACT_DIR}" \
  --extract "${FILE%.fst}" \
  --record_hints \
  "${FILE}"

export OCAMLPATH=${FSTAR_HOME}/bin

ocamlfind opt \
  -package fstarlib -linkpkg -g \
  "${OCAML_EXTRACT_DIR}/${NAME}.ml" \
  -o "${NAME}.exe"

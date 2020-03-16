#!/usr/bin/env bash

set -eu

FILE=$1
OUTDIR=${2:-ocaml-extracted}

fstar --codegen OCaml --odir "${OUTDIR}" "${FILE}"

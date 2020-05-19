#!/usr/bin/env bash

set -eu

if [ -z "$GAUCHE_DOC" ]; then
    echo "Please set GAUCHE_DOC to gauche doc path (*.texi are there)" >&2
    exit 1
fi

fd . -e texi "$GAUCHE_DOC" -x grep '^@def' '{}' \
    | sort \
    | uniq

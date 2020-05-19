#!/usr/bin/env bash

set -euo pipefail

if [ -z "$VIM_RUNTIME" ]; then
    echo "Please set VIM_RUNTIME to vim runtime path" >&2
    exit 1
fi

awk '/^@defmac/ { print $2 }' "$1" | while read mac; do
    if [ "$mac" = '^c' ]; then
        # ^c where c is one of [_a-z] is a macro in gauche
        echo "syn match schemeSyntax /\^[_a-z]/"
    elif ! grep "syn keyword schemeSyntax $mac" \
        "$VIM_RUNTIME"/syntax/scheme.vim > /dev/null 2>&1
    then
        echo "syn keyword schemeSyntax $mac"
    fi
done

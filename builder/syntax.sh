#!/usr/bin/env bash

set -euo pipefail

echo "\
\" Vim syntax file
\" Language: Scheme (Gauche)
\" Last Change: $(date +"%Y-%m-%d")
\" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
\" URL: https://github.com/mnacamura/vim-gauche-syntax
\" Notes: This is supplemental syntax, to be loaded after the core Scheme
\" syntax file (syntax/scheme.vim). Enable it by setting b:is_gauche=1
\" and filetype=scheme.

if !exists('b:did_scheme_syntax')
  finish
endif
"

for file in "$@"; do
    cat "$file"
done

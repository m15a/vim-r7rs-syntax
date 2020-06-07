" Helper functions for gauche-syntax plugin
" Last Change: 2020-06-07
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: MIT

fun! r7rs#get(varname, default) abort
  let l:prefixed_varname = 'r7rs_' . a:varname
  return get(b:, l:prefixed_varname, get(g:, l:prefixed_varname, a:default))
endfun

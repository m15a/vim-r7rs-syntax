" Helper functions for r7rs-syntax plugin
" Last Change: 2021-06-21
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if exists('g:autoloaded_r7rs')
  finish
endif
let g:autoloaded_r7rs = 1

" Get value from a buffer-local or global variable with fall back.
fun! r7rs#GetOption(varname, default) abort
  let l:prefixed_varname = 'r7rs_' . a:varname
  return get(b:, l:prefixed_varname, get(g:, l:prefixed_varname, a:default))
endfun

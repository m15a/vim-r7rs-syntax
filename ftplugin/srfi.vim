" Vim filetype plugin file
" Language: Scheme
" Last Change: 2021-06-27
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if !exists('b:did_r7rs_ftplugin')
  finish
endif

" lispwords {{{

setl lispwords+=and-let*,assume

" }}}

" vim: et sw=2 sts=-1 tw=100 fdm=marker

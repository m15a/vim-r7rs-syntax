" Vim filetype plugin file
" Language: Scheme (R7RS)
" Last Change: 2020-07-04
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if !exists('b:did_r7rs_ftplugin')
  finish
endif

" lispwords {{{

setl lispwords+=define-stream,stream-lambda,stream-let,stream-match,stream-of

" }}}

" vim: et sw=2 sts=-1 tw=100 fdm=marker

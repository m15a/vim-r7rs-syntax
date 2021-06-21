" Vim syntax file
" Language: Scheme
" Last Change: 2021-06-22
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if !exists('b:did_r7rs_syntax')
  finish
endif

" SRFI-2 {{{1
syn keyword r7rsSyntax and-let*

" }}}

" vim: et sw=2 sts=-1 tw=100 fdm=marker

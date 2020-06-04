" Vim indent file
" Language: Scheme (R7RS-small)
" Last Change: 2020-06-04
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: MIT

if exists("b:did_indent")
  finish
endif

setl autoindent
setl nosmartindent

let b:undo_indent = "setl ai< si<"

let b:did_indent = 1

" vim: et sw=2 sts=-1 tw=150 fdm=marker

" Vim indent file
" Language: Scheme (R7RS)
" Last Change: 2020-06-15
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if exists("b:did_indent")
  finish
endif

setl autoindent
setl nosmartindent
setl shiftwidth=2 softtabstop=-1 expandtab

let b:undo_indent = "setl ai< si< sw< sts< et<"

let b:did_indent = 1

" vim: et sw=2 sts=-1 tw=100 fdm=marker

" Vim indent file
" Language: Scheme (R7RS-small)
" Last change: 2020-05-31
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: Public domain

if exists("b:did_indent")
  finish
endif

setl autoindent
setl nosmartindent

let b:undo_indent = "setl ai< si<"

let b:did_indent = 1

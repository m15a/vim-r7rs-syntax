" Vim syntax file
" Language: Scheme (Gauche)
" Last change: 2020-05-31
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: MIT

if !exists('b:current_syntax')
  finish
endif

if !exists('b:r7rs_use_gauche')
  let b:r7rs_use_gauche = get(g:, 'r7rs_use_gauche', 0)
endif

if !b:r7rs_use_gauche
  finish
endif

let s:cpo = &cpo
set cpo&vim

let b:did_r7rs_syntax = 1
runtime! syntax/gauche.vim
unlet b:did_r7rs_syntax

let &cpo = s:cpo
unlet s:cpo

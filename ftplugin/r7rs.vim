" Vim filetype plugin file
" Language: Scheme (R7RS-small)
" Last Change: 2020-05-31
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: Public domain

if exists('b:did_ftplugin')
  finish
endif

let s:cpo = &cpo
set cpo&vim

setl comments=:;;;;,:;;;,:;;,:;
setl commentstring=;\ %s
setl define=^\s*(define\\k*
setl iskeyword=@,33,35-38,42-43,45-58,60-64,94,95,126
setl lisp

setl lispwords+=case
setl lispwords+=define
setl lispwords+=define-syntax
setl lispwords+=if
setl lispwords+=lambda
setl lispwords+=let
setl lispwords+=let*
setl lispwords+=let-syntax
setl lispwords+=letrec
setl lispwords+=letrec-syntax
setl lispwords+=set!
setl lispwords+=unless
setl lispwords+=when

let b:undo_ftplugin = 'setl com< cms< def< isk< lisp< lw<'

let b:did_ftplugin = 1
let &cpo = s:cpo
unlet s:cpo

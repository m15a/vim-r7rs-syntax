" Vim filetype plugin file
" Language: Scheme (R7RS)
" Last Change: 2020-06-11
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if exists('b:did_ftplugin')
  finish
endif

let s:cpo = &cpo
set cpo&vim

" Options {{{1

if r7rs#get('strict', 0)
  let s:use_gauche = 0
else
  let s:use_gauche = r7rs#get('use_gauche', 0)
endif

" }}}

setl comments=:;;;;,:;;;,:;;,:;
setl commentstring=;\ %s
setl define=^\s*(define\\k*
setl iskeyword=@,33,35-38,42-43,45-58,60-64,94,95,126
setl lisp

" lispwords {{{

setl lispwords=lambda,case,when,unless,let,let*,letrec,letrec*,let-values,let*-values,do
setl lispwords+=parameterize,guard,let-syntax,letrec-syntax,syntax-rules,syntax-error,define
setl lispwords+=define-syntax,define-record-type,define-library

" }}}

let b:undo_ftplugin = 'setl com< cms< def< isk< lisp< lw<'

let b:did_ftplugin = 1

let b:did_r7rs_ftplugin = 1
if s:use_gauche
  runtime! ftplugin/gauche.vim
endif
unlet b:did_r7rs_ftplugin

let &cpo = s:cpo
unlet s:cpo

" vim: et sw=2 sts=-1 tw=100 fdm=marker

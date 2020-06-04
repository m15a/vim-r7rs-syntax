" Vim filetype plugin file
" Language: Scheme (R7RS-small)
" Last Change: 2020-06-04
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: MIT

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

" lispwords {{{

setl lispwords+=lambda,set!,case,when,unless,let,let*,letrec,letrec*,let-values,let*-values
setl lispwords+=parameterize,guard,let-syntax,letrec-syntax,syntax-rules,define,define-values
setl lispwords+=define-syntax,define-record-type,define-library

" }}}

let b:undo_ftplugin = 'setl com< cms< def< isk< lisp< lw<'

let b:did_ftplugin = 1
let &cpo = s:cpo
unlet s:cpo

" vim: et sw=2 sts=-1 tw=100 fdm=marker

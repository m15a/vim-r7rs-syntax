" Vim filetype plugin file
" Language: Scheme (R7RS)
" Last Change: 2020-07-04
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if exists('b:did_ftplugin')
  finish
endif

let s:cpo = &cpo
set cpo&vim

" Options {{{1

if r7rs#Get('strict', 0)
  let s:use_gauche = 0
else
  let s:use_gauche = r7rs#Get('use_gauche', 0)
endif

" }}}

setl iskeyword=@,33,35-38,42-43,45-58,60-64,94-95,126
" 32: SPACE
" 34: "
" 35: #
" NOTE: `#` is required to allow highlighting numbers and booleans (e.g., `#e1.0` and `#false`)
" 39: '
" 40,41: ()
" 44: ,
" 59: ;
" 65-90: A-Z (included in @)
" 91,93: []
" 92: \
" 96: `
" 97-122: a-z (included in @)
" 123,125: {}
" 124: |
" 127: DEL

setl define=^\s*(define\\k*

setl comments=n:;
setl commentstring=;\ %s

setl lisp

" lispwords {{{

setl lispwords=lambda,case,when,unless,let,let*,letrec,letrec*,let-values,let*-values,do
setl lispwords+=parameterize,guard,let-syntax,letrec-syntax,syntax-rules,syntax-error,define
setl lispwords+=define-syntax,define-record-type,define-library

" }}}

if &omnifunc == ''
  setl omnifunc=syntaxcomplete#Complete
endif

let b:undo_ftplugin = 'setl isk< def< com< cms< lisp< lw< ofu<'

let b:did_ftplugin = 1

let b:did_r7rs_ftplugin = 1
runtime! ftplugin/r7rs-large.vim
if s:use_gauche
  runtime! ftplugin/gauche.vim
endif
unlet b:did_r7rs_ftplugin

let &cpo = s:cpo
unlet s:cpo

" vim: et sw=2 sts=-1 tw=100 fdm=marker

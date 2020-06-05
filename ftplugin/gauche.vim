" Vim filetype plugin file
" Language: Scheme (Gauche)
" Last Change: 2020-06-05
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: MIT

if !exists('b:did_r7rs_ftplugin')
  finish
endif

" lispwords {{{

setl lispwords+=and-let*
setl lispwords+=and-let1
setl lispwords+=cgen-with-cpp-condition
setl lispwords+=define-cise-expr
setl lispwords+=define-cise-macro
setl lispwords+=define-cise-stmt
setl lispwords+=define-cise-toplevel
setl lispwords+=define-class
setl lispwords+=define-condition-type
setl lispwords+=define-constant
setl lispwords+=define-dict-interface
setl lispwords+=define-generic
setl lispwords+=define-in-module
setl lispwords+=define-inline
setl lispwords+=define-macro
setl lispwords+=define-method
setl lispwords+=define-module
setl lispwords+=define-stream
setl lispwords+=do-generator
setl lispwords+=dolist
setl lispwords+=dotimes
setl lispwords+=dynamic-lambda
setl lispwords+=ecase
setl lispwords+=fluid-let
setl lispwords+=glet*
setl lispwords+=glet1
setl lispwords+=if-let1
setl lispwords+=let-args
setl lispwords+=let-keywords
setl lispwords+=let-keywords*
setl lispwords+=let-optionals*
setl lispwords+=let-string-start+end
setl lispwords+=let/cc
setl lispwords+=let1
setl lispwords+=match
setl lispwords+=match-define
setl lispwords+=match-let
setl lispwords+=match-let*
setl lispwords+=match-let1
setl lispwords+=match-letrec
setl lispwords+=parse-options
setl lispwords+=receive
setl lispwords+=rlet1
setl lispwords+=rxmatch-case
setl lispwords+=rxmatch-let
setl lispwords+=set!-values
setl lispwords+=stream-lambda
setl lispwords+=stream-let
setl lispwords+=stream-match
setl lispwords+=until
setl lispwords+=while
setl lispwords+=with-builder
setl lispwords+=with-cf-subst
setl lispwords+=with-iterator
setl lispwords+=with-module
setl lispwords+=with-signal-handlers
setl lispwords+=with-time-counter

" }}}

" vim: et sw=2 sts=-1 tw=100 fdm=marker

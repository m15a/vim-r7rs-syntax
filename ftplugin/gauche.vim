" Vim filetype plugin file
" Language: Scheme (Gauche)
" Last Change: 2020-05-20
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche
" License: Public domain
" Notes: To enable this plugin, set filetype=scheme and (b|g):is_gauche=1.

if !exists('b:did_scheme_ftplugin')
  finish
endif

setl lispwords+=and-let*
setl lispwords+=and-let1
setl lispwords+=case-lambda
setl lispwords+=char-set:ascii-letter
setl lispwords+=char-set:ascii-letter+digit
setl lispwords+=char-set:ascii-lower-case
setl lispwords+=char-set:ascii-upper-case
setl lispwords+=char-set:letter
setl lispwords+=char-set:letter+digit
setl lispwords+=char-set:lower-case
setl lispwords+=char-set:title-case
setl lispwords+=char-set:upper-case
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
setl lispwords+=define-library
setl lispwords+=define-macro
setl lispwords+=define-method
setl lispwords+=define-module
setl lispwords+=define-stream
setl lispwords+=do-ec
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
setl lispwords+=match-lambda
setl lispwords+=match-lambda*
setl lispwords+=match-let
setl lispwords+=match-let*
setl lispwords+=match-let1
setl lispwords+=match-letrec
setl lispwords+=rlet1
setl lispwords+=rxmatch-case
setl lispwords+=rxmatch-cond
setl lispwords+=rxmatch-if
setl lispwords+=rxmatch-let
setl lispwords+=set!-values
setl lispwords+=stream-lambda
setl lispwords+=stream-let
setl lispwords+=stream-match

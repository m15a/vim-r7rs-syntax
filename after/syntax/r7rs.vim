" Vim syntax file
" Language: Scheme (Gauche)
" Last Change: 2020-06-07
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: MIT

if !exists('b:current_syntax')
  finish
endif

if !r7rs#get('use_gauche', 0)
  finish
endif

let s:cpo = &cpo
set cpo&vim

fun! s:check_conflict(option)
  if !exists(a:option)
    return
  endif
  let l:value = eval(a:option)
  if l:value
    echoe "gauche-syntax: '" . a:option . " = " . l:value ."' is not compatible with Gauche"
  endif
endfun
call s:check_conflict('b:r7rs_strict')
call s:check_conflict('g:r7rs_strict')
call s:check_conflict('b:r7rs_strict_identifier')
call s:check_conflict('g:r7rs_strict_identifier')

let b:did_r7rs_syntax = 1
runtime! syntax/gauche.vim
unlet b:did_r7rs_syntax

let &cpo = s:cpo
unlet s:cpo

" vim: et sw=2 sts=-1 tw=100 fdm=marker

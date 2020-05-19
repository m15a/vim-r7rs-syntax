if !exists('b:current_syntax') || b:current_syntax != 'scheme'
  finish
endif

if !exists('b:is_gauche') && !exists('g:is_gauche')
  finish
endif

let s:cpo = &cpo
set cpo&vim

let b:did_scheme_syntax = 1
exe 'ru! syntax/gauche.vim'
unlet b:did_scheme_syntax

let &cpo = s:cpo
unlet s:cpo

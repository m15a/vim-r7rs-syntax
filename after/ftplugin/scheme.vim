if !exists('b:did_ftplugin')
  finish
endif

if !exists('b:is_gauche') && !exists('g:is_gauche')
  finish
endif

let s:cpo = &cpo
set cpo&vim

let b:did_scheme_ftplugin = 1
exe 'ru! ftplugin/gauche.vim'
unlet b:did_scheme_ftplugin

let &cpo = s:cpo
unlet s:cpo

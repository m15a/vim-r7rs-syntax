" Vim filetype plugin file
" Language: Scheme (Gauche)
" Last Change: 2020-05-31
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: MIT

if !exists('b:did_ftplugin')
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

let b:did_r7rs_ftplugin = 1
runtime! ftplugin/gauche.vim
unlet b:did_r7rs_ftplugin

let &cpo = s:cpo
unlet s:cpo

" vim: et sw=2 sts=-1 tw=100 fdm=marker

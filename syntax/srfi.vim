" Vim syntax file
" Language: Scheme
" Last Change: 2021-06-25
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if !exists('b:did_r7rs_syntax')
  finish
endif

" SRFI-2 {{{1
syn keyword r7rsSyntax and-let*

" SRFI-22 {{{1
syn cluster r7rsComments add=r7rsShebang
syn match r7rsShebang /\%^#! .*$/

" SRFI-112 {{{1
syn keyword r7rsFunction implementation-name implementation-version cpu-architecture machine-name
syn keyword r7rsFunction os-name os-version

" SRFI-118 {{{1
syn keyword r7rsFunctionM string-append! string-replace!

" SRFI-120 {{{1
syn keyword r7rsFunction make-timer timer? timer-task-exists? make-timer-delta timer-delta?
syn keyword r7rsFunctionM timer-cancel! timer-schedule! timer-reschedule! timer-task-remove!

" SRFI-129 {{{1
syn keyword r7rsFunction char-title-case? char-titlecase string-titlecase

" SRFI-145 {{{1
syn keyword r7rsSyntax assume

" Highlights {{{1

hi def link r7rsShebang r7rsComment

" }}}

" vim: et sw=2 sts=-1 tw=100 fdm=marker

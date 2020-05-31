" Vim syntax file
" Language: Scheme (R7RS-small)
" Last Change: 2020-05-31
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: Public domain

if exists('b:current_syntax')
  finish
endif

let s:cpo = &cpo
set cpo&vim

if !exists('b:r7rs_use_square_brackets')
  let b:r7rs_use_square_brackets = get(g:, 'r7rs_use_square_brackets', 1)
endif

syn match r7rsDelimiter /[[:space:]\n|()";]/
if b:r7rs_use_square_brackets
  syn match r7rsDelimiter /[\[\]]/
endif

syn cluster r7rsComments
      \ contains=r7rsComment,r7rsNestedComment,r7rsSharpComment
syn region r7rsComment start=/#\@<!;/ end=/$/
syn region r7rsNestedComment start=/#|/ end=/|#/ contains=r7rsNestedComment
" TODO: highlight nested #;
" Example: in `#; #; hello hello r7rs!` all `hello` should be r7rsSharpCommentDatum
syn region r7rsSharpComment start=/#;/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ skipempty
      \ contains=@r7rsComments,r7rsDirective
      \ nextgroup=r7rsSharpCommentDatum
" TODO: Add more datum pattern
" syn region r7rsSharpCommentDatum start=/(/ end=/)/ contained
" if b:r7rs_use_square_brackets
"   syn region r7rsSharpCommentDatum start=/\[/ end=/\]/ contained
" endif

syn match r7rsDirective /#![^[:space:]\n|()";'`,\#\[\]{}]\+/
syn region gaucheShebang start=/\%^#![/ ]/ end=/$/

syn match r7rsIdentifier /[^[:space:]\n|()";'`,\#\[\]{}]\+/
syn match r7rsSharpCommentDatum /[^[:space:]\n|()";'`,\#\[\]{}]\+/ contained

syn region r7rsIdentifier start=/|\zs/ skip=/\\[\\|]/ end=/\ze|/
syn region r7rsSharpCommentDatum start=/|/ skip=/\\[\\|]/ end=/|/ contained

syn region r7rsQuote start=/'['`]*/ end=/\ze[[:space:]\n|()";]/ contains=r7rsIdentifier

hi link r7rsDelimiter Delimiter
hi link r7rsComment Comment
hi link r7rsNestedComment r7rsComment
hi link r7rsSharpComment r7rsComment
hi link r7rsSharpCommentDatum r7rsSharpComment
hi link r7rsDirective r7rsComment
hi link gaucheShebang r7rsComment
hi link r7rsIdentifier PreProc
hi link r7rsQuote r7rsDelimiter

let b:current_syntax = 'r7rs'

let &cpo = s:cpo
unlet s:cpo

" vim: tw=98 fdm=marker

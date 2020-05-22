if !exists('b:current_syntax') || b:current_syntax != 'scheme'
  finish
endif

if !exists('b:is_gauche') && !exists('g:is_gauche')
  finish
endif

let s:cpo = &cpo
set cpo&vim

" Fix syntax/scheme.vim {{{

syn region schemeQuote matchgroup=schemeData start=/'['`]*\[/ end=/\]/ contains=ALLBUT,schemeQuasiquote,schemeQuasiquoteForm,schemeUnquote,schemeForm,schemeDatumCommentForm,schemeImport,@schemeImportCluster,@schemeSyntaxCluster
syn region schemeQuasiquote matchgroup=schemeData start=/`['`]*\[/ end=/\]/ contains=ALLBUT,schemeQuote,schemeQuoteForm,schemeForm,schemeDatumCommentForm,schemeImport,@schemeImportCluster,@schemeSyntaxCluster
syn region schemeUnquote matchgroup=schemeParentheses start=/,\[/ end=/\]/ contained contains=ALLBUT,schemeDatumCommentForm,@schemeImportCluster
syn region schemeUnquote matchgroup=schemeParentheses start=/,@\[/ end=/\]/ contained contains=ALLBUT,schemeDatumCommentForm,@schemeImportCluster
syn region schemeQuoteForm matchgroup=schemeData start=/\(#\)\@<!\[/ end=/\]/ contained contains=ALLBUT,schemeQuasiquote,schemeQuasiquoteForm,schemeUnquote,schemeForm,schemeDatumCommentForm,schemeImport,@schemeImportCluster,@schemeSyntaxCluster
syn region schemeQuasiquoteForm matchgroup=schemeData start=/\(#\)\@<!\[/ end=/\]/ contained contains=ALLBUT,schemeQuote,schemeForm,schemeDatumCommentForm,schemeImport,@schemeImportCluster,@schemeSyntaxCluster

" }}}

let b:did_scheme_syntax = 1
exe 'ru! syntax/gauche.vim'
unlet b:did_scheme_syntax

let &cpo = s:cpo
unlet s:cpo

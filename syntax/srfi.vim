" Vim syntax file
" Language: Scheme
" Last Change: 2021-07-04
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if !exists('b:did_r7rs_syntax')
  finish
endif

" Options {{{1

" If (b|g):r7rs_strict is true, the following options are set to obey strict R7RS.
if r7rs#GetOption('strict', 0)
  let s:brackets_as_parens = 0
  let s:braces_as_parens = 0
else
  let s:more_parens = r7rs#GetOption('more_parens', ']')
  let s:brackets_as_parens = match(s:more_parens, '[\[\]]') > -1
  let s:braces_as_parens = match(s:more_parens, '[{}]') > -1
  unlet s:more_parens
endif

" }}}

" SRFI 2 {{{1
syn keyword r7rsSyntax and-let*

" SRFI-7 {{{1
syn region r7rsProgram matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*program/ end=/)/ contains=r7rsError,@r7rsComments,r7rsProgramSyntax,r7rsProgramClause
syn keyword r7rsProgramSyntax contained program and or not
syn keyword r7rsProgramSyntaxA contained requires files code feature-cond
syn region r7rsProgramClause matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*requires/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsProgramSyntaxA,r7rsCEFeatureId
syn region r7rsProgramClause matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*files/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsProgramSyntaxA,r7rsString
syn region r7rsProgramClause matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*code/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsProgramSyntaxA,@r7rsExpressions
syn region r7rsProgramClause matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*feature-cond/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsProgramSyntaxA,r7rsProgramFCClause
syn region r7rsProgramFCClause matchgroup=r7rsDelimiter start=/(/ end=/)/ contained contains=r7rsError,@r7rsComments,@r7rsProgramFCRequirements,r7rsProgramClause
syn cluster r7rsProgramFCRequirements contains=r7rsCEFeatureId,r7rsProgramFCRequirementsAON,r7rsFCRequirementsElse
syn region r7rsProgramFCRequirementsAON matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*\%(and\|or\|not\)/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsProgramSyntax,@r7rsProgramFCRequirements
syn keyword r7rsProgramFCRequirementsElse contained else
if s:brackets_as_parens
  syn region r7rsProgram matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*program/ end=/\]/ contains=r7rsError,@r7rsComments,r7rsProgramSyntax,r7rsProgramClause
  syn region r7rsProgramClause matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*requires/ end=/\]/ contained contains=r7rsError,@r7rsComments,r7rsProgramSyntaxA,r7rsCEFeatureId
  syn region r7rsProgramClause matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*files/ end=/\]/ contained contains=r7rsError,@r7rsComments,r7rsProgramSyntaxA,r7rsString
  syn region r7rsProgramClause matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*code/ end=/\]/ contained contains=r7rsError,@r7rsComments,r7rsProgramSyntaxA,@r7rsExpressions
  syn region r7rsProgramClause matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*feature-cond/ end=/\]/ contained contains=r7rsError,@r7rsComments,r7rsProgramSyntaxA,r7rsProgramFCClause
  syn region r7rsProgramFCClause matchgroup=r7rsDelimiter start=/\[/ end=/\]/ contained contains=r7rsError,@r7rsComments,@r7rsProgramFCRequirements,r7rsProgramClause
endif
if s:braces_as_parens
  syn region r7rsProgram matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*program/ end=/}/ contains=r7rsError,@r7rsComments,r7rsProgramSyntax,r7rsProgramClause
  syn region r7rsProgramClause matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*requires/ end=/}/ contained contains=r7rsError,@r7rsComments,r7rsProgramSyntaxA,r7rsCEFeatureId
  syn region r7rsProgramClause matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*files/ end=/}/ contained contains=r7rsError,@r7rsComments,r7rsProgramSyntaxA,r7rsString
  syn region r7rsProgramClause matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*code/ end=/}/ contained contains=r7rsError,@r7rsComments,r7rsProgramSyntaxA,@r7rsExpressions
  syn region r7rsProgramClause matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*feature-cond/ end=/}/ contained contains=r7rsError,@r7rsComments,r7rsProgramSyntaxA,r7rsProgramFCClause
  syn region r7rsProgramFCClause matchgroup=r7rsDelimiter start=/{/ end=/}/ contained contains=r7rsError,@r7rsComments,@r7rsProgramFCRequirements,r7rsProgramClause
endif

" SRFI 8 {{{1
syn keyword r7rsSyntax receive

" SRFI 17 {{{1
syn keyword r7rsFunction setter getter-with-setter

" SRFI 18 {{{1
syn keyword r7rsFunction current-thread thread? make-thread thread-name thread-specific
syn keyword r7rsFunctionM thread-specific-set! thread-start! thread-yield! thread-sleep!
syn keyword r7rsFunctionM thread-terminate! thread-join!
syn keyword r7rsFunction mutex? make-mutex mutex-name mutex-specific mutex-state
syn keyword r7rsFunctionM mutex-specific-set! mutex-lock! mutex-unlock!
syn keyword r7rsFunction condition-variable? make-condition-variable condition-variable-name
syn keyword r7rsFunction condition-variable-specific
syn keyword r7rsFunctionM condition-variable-specific-set! condition-variable-signal!
syn keyword r7rsFunctionM condition-variable-broadcast!
syn keyword r7rsFunction current-time time? time->seconds seconds->time
syn keyword r7rsFunction current-exception-handler
syn keyword r7rsFunction join-timeout-exception? abondoned-mutex-exception?
syn keyword r7rsFunction terminated-thread-exception? uncaught-exception? uncaught-exception-reason

" SRFI 21 {{{1
syn keyword r7rsFunction thread-base-priority thread-priority-boost thread-quantum
syn keyword r7rsFunctionM thread-base-priority-set! thread-priority-boost-set!
syn keyword r7rsFunctionM thread-quantum-set!

" SRFI 22 {{{1
syn cluster r7rsComments add=r7rsShebang
syn match r7rsShebang /\%^#! .*$/

" SRFI 25 {{{1
syn keyword r7rsFunction array? make-array shape array array-rank array-start array-end array-ref
syn keyword r7rsFunction share-array
syn keyword r7rsFunctionM array-set!

" SRFI 26 {{{1
syn keyword r7rsSyntax cut cute
syn keyword r7rsSyntaxA <> <...>

" SRFI 27 {{{1
syn keyword r7rsFunction random-integer random-real make-random-source random-source?
syn keyword r7rsFunction random-source-state-ref random-source-make-integers
syn keyword r7rsFunction random-source-make-reals
syn keyword r7rsFunctionM random-source-state-set! random-source-randomize!
syn keyword r7rsFunctionM random-source-pseudo-randomize!
syn keyword r7rsVariable default-random-source

" SRFI 112 {{{1
syn keyword r7rsFunction implementation-name implementation-version cpu-architecture machine-name
syn keyword r7rsFunction os-name os-version

" SRFI 118 {{{1
syn keyword r7rsFunctionM string-append! string-replace!

" SRFI 120 {{{1
syn keyword r7rsFunction make-timer timer? timer-task-exists? make-timer-delta timer-delta?
syn keyword r7rsFunctionM timer-cancel! timer-schedule! timer-reschedule! timer-task-remove!

" SRFI 129 {{{1
syn keyword r7rsFunction char-title-case? char-titlecase string-titlecase

" SRFI 145 {{{1
syn keyword r7rsSyntax assume

" SRFI 152 {{{1

syn keyword r7rsFunction string-null? string-every string-any string-tabulate
syn keyword r7rsFunction string-unfold string-unfold-right reverse-list->string
syn keyword r7rsFunction string-take string-take-right string-drop string-drop-right
syn keyword r7rsFunction string-pad string-pad-right string-trim string-trim-right string-trim-both
syn keyword r7rsFunction string-replace
syn keyword r7rsFunction string-prefix-length string-suffix-length string-prefix? string-suffix?
syn keyword r7rsFunction string-index string-index-right string-skip string-skip-right
syn keyword r7rsFunction string-contains string-contains-right string-take-while
syn keyword r7rsFunction string-take-while-right string-drop-while string-drop-while-right
syn keyword r7rsFunction string-break string-span string-concatenate string-concatenate-reverse
syn keyword r7rsFunction string-join
syn keyword r7rsFunction string-fold string-fold-right string-count string-filter string-remove
syn keyword r7rsFunction string-replicate string-segment string-split

" Highlights {{{1

hi def link r7rsShebang r7rsComment
hi def link r7rsProgramSyntax r7rsLibrarySyntax
hi def link r7rsProgramSyntaxA r7rsLibrarySyntaxA
hi def link r7rsProgramFCRequirementsElse r7rsProgramSyntaxA

" }}}

" vim: et sw=2 sts=-1 tw=100 fdm=marker

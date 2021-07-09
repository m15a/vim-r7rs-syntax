" Vim syntax file
" Language: Scheme
" Last Change: 2021-07-10
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if !exists('b:did_r7rs_syntax')
  finish
endif

" SRFI 2 {{{1
syn keyword r7rsSyntax and-let*

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

" SRFI 206 {{{1
syn keyword r7rsSyntaxM define-auxiliary-syntax
syn keyword r7rsVariable auxiliary-syntax-name

" SRFI 212 {{{1
syn keyword r7rsSyntaxM alias

" SRFI 213 {{{1
syn keyword r7rsSyntaxM define-property
syn keyword r7rsFunction capture-lookup

" SRFI 217 {{{1
syn keyword r7rsFunction iset iset-unfold make-range-iset iset? iset-contains? iset-empty?
syn keyword r7rsFunction iset-disjoint? iset-member iset-min iset-max
syn keyword r7rsFunction iset-adjoin iset-delete iset-delete-all iset-search iset-delete-min
syn keyword r7rsFunction iset-delete-max
syn keyword r7rsFunctionM iset-adjoin! iset-delete! iset-delete-all! iset-search! iset-delete-min!
syn keyword r7rsFunctionM iset-delete-max!
syn keyword r7rsFunction iset-size iset-find iset-count iset-any? iset-every?
syn keyword r7rsFunction iset-map iset-for-each iset-fold iset-fold-right iset-filter iset-remove
syn keyword r7rsFunction iset-partition iset-copy iset->list list->iset
syn keyword r7rsFunctionM iset-filter! iset-remove! iset-partition! list->iset!
syn keyword r7rsFunction iset=? iset<? iset>? iset<=? iset>=?
syn keyword r7rsFunction iset-union iset-intersection iset-difference iset-xor
syn keyword r7rsFunctionM iset-union! iset-intersection! iset-difference! iset-xor!
syn keyword r7rsFunction iset-open-interval iset-closed-interval iset-open-closed-interval
syn keyword r7rsFunction iset-closed-open-interval isubset= isubset< isubset<= isubset> isubset>=

" SRFI 221 {{{1
syn keyword r7rsFunction gcompose-left gcompose-right accumulate-generated-values genumerate
syn keyword r7rsFunction gchoice stream->generator generator->stream

" Highlights {{{1

hi def link r7rsShebang r7rsComment

" }}}

" vim: et sw=2 sts=-1 tw=100 fdm=marker

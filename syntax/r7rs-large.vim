" Vim syntax file
" Language: Scheme (R7RS)
" Last Change: 2021-06-27
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if !exists('b:did_r7rs_syntax')
  finish
endif

" (scheme list) SRFI 1 {{{1
syn keyword r7rsFunction xcons cons* list-tabulate circular-list iota
syn keyword r7rsFunction proper-list? circular-list? dotted-list? not-pair? null-list? list=
syn keyword r7rsFunction first second third fourth fifth sixth seventh eighth ninth tenth
syn keyword r7rsFunction car+cdr take drop take-right drop-right split-at
syn keyword r7rsFunction last last-pair length+ concatenate append-reverse
syn keyword r7rsFunction zip unzip1 unzip2 unzip3 unzip4 unzip5 count
syn keyword r7rsFunction fold unfold pair-fold reduce fold-right unfold-right pair-fold-right
syn keyword r7rsFunction reduce-right append-map pair-for-each filter-map map-in-order
syn keyword r7rsFunction filter partition remove find find-tail any every list-index
syn keyword r7rsFunction take-while drop-while span break delete delete-duplicates
syn keyword r7rsFunction alist-cons alist-copy alist-delete
syn keyword r7rsFunction lset<= lset= lset-adjoin lset-union lset-intersection lset-difference
syn keyword r7rsFunction lset-xor lset-diff+intersection
syn keyword r7rsFunctionM take! drop-right! split-at! append! concatenate! reverse! append-reverse!
syn keyword r7rsFunctionM append-map! map! filter! partition! remove! take-while! span! break!
syn keyword r7rsFunctionM delete! delete-duplicates! alist-delete!
syn keyword r7rsFunctionM lset-union! lset-intersection! lset-difference! lset-xor!
syn keyword r7rsFunctionM lset-diff+intersection!

" (scheme vector) SRFI 133 {{{1
syn keyword r7rsFunction vector-unfold vector-unfold-right vector-reverse-copy vector-concatenate
syn keyword r7rsFunction vector-append-subvectors vector-empty? vector=
syn keyword r7rsFunction vector-fold vector-fold-right vector-count vector-cumulate
syn keyword r7rsFunction vector-index vector-index-right vector-skip vector-skip-right
syn keyword r7rsFunction vector-binary-search vector-any vector-every vector-partition
syn keyword r7rsFunction reverse-vector->list reverse-list->vector
syn keyword r7rsFunctionM vector-map! vector-swap! vector-reverse! vector-reverse-copy!
syn keyword r7rsFunctionM vector-unfold! vector-unfold-right!

" (scheme vector @) SRFI 160 {{{1
syn clear r7rsBytevector
syn cluster r7rsSimpleData remove=r7rsBytevector add=r7rsNumericVector
syn region r7rsNumericVector matchgroup=r7rsDelimiter start=/#[su]\%(8\|16\|32\|64\)(/ end=/)/ contains=r7rsError,@r7rsComments,r7rsNumber
syn region r7rsNumericVector matchgroup=r7rsDelimiter start=/#f\%(32\|64\)(/ end=/)/ contains=r7rsError,@r7rsComments,r7rsNumber
syn region r7rsNumericVector matchgroup=r7rsDelimiter start=/#c\%(64\|128\)(/ end=/)/ contains=r7rsError,@r7rsComments,r7rsNumber

" s8 {{{2
syn keyword r7rsFunction make-s8vector s8vector s8vector-unfold s8vector-unfold-right
syn keyword r7rsFunction s8vector-copy s8vector-reverse-copy s8vector-append
syn keyword r7rsFunction s8vector-concatenate s8vector-append-subvectors s8? s8vector?
syn keyword r7rsFunction s8vector-empty? s8vector= s8vector-ref s8vector-length s8vector-take
syn keyword r7rsFunction s8vector-take-right s8vector-drop s8vector-drop-right s8vector-segment
syn keyword r7rsFunction s8vector-fold s8vector-fold-right s8vector-map s8vector-for-each
syn keyword r7rsFunction s8vector-count s8vector-cumulate s8vector-take-while
syn keyword r7rsFunction s8vector-take-while-right s8vector-drop-while s8vector-drop-while-right
syn keyword r7rsFunction s8vector-index s8vector-index-right s8vector-skip s8vector-skip-right
syn keyword r7rsFunction s8vector-any s8vector-every s8vector-partition s8vector-filter
syn keyword r7rsFunction s8vector-remove s8vector->list reverse-s8vector->list list->s8vector
syn keyword r7rsFunction reverse-list->s8vector s8vector->vector vector->s8vector
syn keyword r7rsFunction make-s8vector-generator s8vector-comparator write-s8vector
syn keyword r7rsFunctionM s8vector-map! s8vector-set! s8vector-swap! s8vector-fill!
syn keyword r7rsFunctionM s8vector-reverse! s8vector-copy! s8vector-reverse-copy!
syn keyword r7rsFunctionM s8vector-unfold! s8vector-unfold-right!

" u8 {{{2
syn keyword r7rsFunction make-u8vector u8vector u8vector-unfold u8vector-unfold-right
syn keyword r7rsFunction u8vector-copy u8vector-reverse-copy u8vector-append
syn keyword r7rsFunction u8vector-concatenate u8vector-append-subvectors u8? u8vector?
syn keyword r7rsFunction u8vector-empty? u8vector= u8vector-ref u8vector-length u8vector-take
syn keyword r7rsFunction u8vector-take-right u8vector-drop u8vector-drop-right u8vector-segment
syn keyword r7rsFunction u8vector-fold u8vector-fold-right u8vector-map u8vector-for-each
syn keyword r7rsFunction u8vector-count u8vector-cumulate u8vector-take-while
syn keyword r7rsFunction u8vector-take-while-right u8vector-drop-while u8vector-drop-while-right
syn keyword r7rsFunction u8vector-index u8vector-index-right u8vector-skip u8vector-skip-right
syn keyword r7rsFunction u8vector-any u8vector-every u8vector-partition u8vector-filter
syn keyword r7rsFunction u8vector-remove u8vector->list reverse-u8vector->list list->u8vector
syn keyword r7rsFunction reverse-list->u8vector u8vector->vector vector->u8vector
syn keyword r7rsFunction make-u8vector-generator u8vector-comparator write-u8vector
syn keyword r7rsFunctionM u8vector-map! u8vector-set! u8vector-swap! u8vector-fill!
syn keyword r7rsFunctionM u8vector-reverse! u8vector-copy! u8vector-reverse-copy!
syn keyword r7rsFunctionM u8vector-unfold! u8vector-unfold-right!

" s16 {{{2
syn keyword r7rsFunction make-s16vector s16vector s16vector-unfold s16vector-unfold-right
syn keyword r7rsFunction s16vector-copy s16vector-reverse-copy s16vector-append
syn keyword r7rsFunction s16vector-concatenate s16vector-append-subvectors s16? s16vector?
syn keyword r7rsFunction s16vector-empty? s16vector= s16vector-ref s16vector-length s16vector-take
syn keyword r7rsFunction s16vector-take-right s16vector-drop s16vector-drop-right s16vector-segment
syn keyword r7rsFunction s16vector-fold s16vector-fold-right s16vector-map s16vector-for-each
syn keyword r7rsFunction s16vector-count s16vector-cumulate s16vector-take-while
syn keyword r7rsFunction s16vector-take-while-right s16vector-drop-while s16vector-drop-while-right
syn keyword r7rsFunction s16vector-index s16vector-index-right s16vector-skip s16vector-skip-right
syn keyword r7rsFunction s16vector-any s16vector-every s16vector-partition s16vector-filter
syn keyword r7rsFunction s16vector-remove s16vector->list reverse-s16vector->list list->s16vector
syn keyword r7rsFunction reverse-list->s16vector s16vector->vector vector->s16vector
syn keyword r7rsFunction make-s16vector-generator s16vector-comparator write-s16vector
syn keyword r7rsFunctionM s16vector-map! s16vector-set! s16vector-swap! s16vector-fill!
syn keyword r7rsFunctionM s16vector-reverse! s16vector-copy! s16vector-reverse-copy!
syn keyword r7rsFunctionM s16vector-unfold! s16vector-unfold-right!

" u16 {{{2
syn keyword r7rsFunction make-u16vector u16vector u16vector-unfold u16vector-unfold-right
syn keyword r7rsFunction u16vector-copy u16vector-reverse-copy u16vector-append
syn keyword r7rsFunction u16vector-concatenate u16vector-append-subvectors u16? u16vector?
syn keyword r7rsFunction u16vector-empty? u16vector= u16vector-ref u16vector-length u16vector-take
syn keyword r7rsFunction u16vector-take-right u16vector-drop u16vector-drop-right u16vector-segment
syn keyword r7rsFunction u16vector-fold u16vector-fold-right u16vector-map u16vector-for-each
syn keyword r7rsFunction u16vector-count u16vector-cumulate u16vector-take-while
syn keyword r7rsFunction u16vector-take-while-right u16vector-drop-while u16vector-drop-while-right
syn keyword r7rsFunction u16vector-index u16vector-index-right u16vector-skip u16vector-skip-right
syn keyword r7rsFunction u16vector-any u16vector-every u16vector-partition u16vector-filter
syn keyword r7rsFunction u16vector-remove u16vector->list reverse-u16vector->list list->u16vector
syn keyword r7rsFunction reverse-list->u16vector u16vector->vector vector->u16vector
syn keyword r7rsFunction make-u16vector-generator u16vector-comparator write-u16vector
syn keyword r7rsFunctionM u16vector-map! u16vector-set! u16vector-swap! u16vector-fill!
syn keyword r7rsFunctionM u16vector-reverse! u16vector-copy! u16vector-reverse-copy!
syn keyword r7rsFunctionM u16vector-unfold! u16vector-unfold-right!

" s32 {{{2
syn keyword r7rsFunction make-s32vector s32vector s32vector-unfold s32vector-unfold-right
syn keyword r7rsFunction s32vector-copy s32vector-reverse-copy s32vector-append
syn keyword r7rsFunction s32vector-concatenate s32vector-append-subvectors s32? s32vector?
syn keyword r7rsFunction s32vector-empty? s32vector= s32vector-ref s32vector-length s32vector-take
syn keyword r7rsFunction s32vector-take-right s32vector-drop s32vector-drop-right s32vector-segment
syn keyword r7rsFunction s32vector-fold s32vector-fold-right s32vector-map s32vector-for-each
syn keyword r7rsFunction s32vector-count s32vector-cumulate s32vector-take-while
syn keyword r7rsFunction s32vector-take-while-right s32vector-drop-while s32vector-drop-while-right
syn keyword r7rsFunction s32vector-index s32vector-index-right s32vector-skip s32vector-skip-right
syn keyword r7rsFunction s32vector-any s32vector-every s32vector-partition s32vector-filter
syn keyword r7rsFunction s32vector-remove s32vector->list reverse-s32vector->list list->s32vector
syn keyword r7rsFunction reverse-list->s32vector s32vector->vector vector->s32vector
syn keyword r7rsFunction make-s32vector-generator s32vector-comparator write-s32vector
syn keyword r7rsFunctionM s32vector-map! s32vector-set! s32vector-swap! s32vector-fill!
syn keyword r7rsFunctionM s32vector-reverse! s32vector-copy! s32vector-reverse-copy!
syn keyword r7rsFunctionM s32vector-unfold! s32vector-unfold-right!

" u32 {{{2
syn keyword r7rsFunction make-u32vector u32vector u32vector-unfold u32vector-unfold-right
syn keyword r7rsFunction u32vector-copy u32vector-reverse-copy u32vector-append
syn keyword r7rsFunction u32vector-concatenate u32vector-append-subvectors u32? u32vector?
syn keyword r7rsFunction u32vector-empty? u32vector= u32vector-ref u32vector-length u32vector-take
syn keyword r7rsFunction u32vector-take-right u32vector-drop u32vector-drop-right u32vector-segment
syn keyword r7rsFunction u32vector-fold u32vector-fold-right u32vector-map u32vector-for-each
syn keyword r7rsFunction u32vector-count u32vector-cumulate u32vector-take-while
syn keyword r7rsFunction u32vector-take-while-right u32vector-drop-while u32vector-drop-while-right
syn keyword r7rsFunction u32vector-index u32vector-index-right u32vector-skip u32vector-skip-right
syn keyword r7rsFunction u32vector-any u32vector-every u32vector-partition u32vector-filter
syn keyword r7rsFunction u32vector-remove u32vector->list reverse-u32vector->list list->u32vector
syn keyword r7rsFunction reverse-list->u32vector u32vector->vector vector->u32vector
syn keyword r7rsFunction make-u32vector-generator u32vector-comparator write-u32vector
syn keyword r7rsFunctionM u32vector-map! u32vector-set! u32vector-swap! u32vector-fill!
syn keyword r7rsFunctionM u32vector-reverse! u32vector-copy! u32vector-reverse-copy!
syn keyword r7rsFunctionM u32vector-unfold! u32vector-unfold-right!

" s64 {{{2
syn keyword r7rsFunction make-s64vector s64vector s64vector-unfold s64vector-unfold-right
syn keyword r7rsFunction s64vector-copy s64vector-reverse-copy s64vector-append
syn keyword r7rsFunction s64vector-concatenate s64vector-append-subvectors s64? s64vector?
syn keyword r7rsFunction s64vector-empty? s64vector= s64vector-ref s64vector-length s64vector-take
syn keyword r7rsFunction s64vector-take-right s64vector-drop s64vector-drop-right s64vector-segment
syn keyword r7rsFunction s64vector-fold s64vector-fold-right s64vector-map s64vector-for-each
syn keyword r7rsFunction s64vector-count s64vector-cumulate s64vector-take-while
syn keyword r7rsFunction s64vector-take-while-right s64vector-drop-while s64vector-drop-while-right
syn keyword r7rsFunction s64vector-index s64vector-index-right s64vector-skip s64vector-skip-right
syn keyword r7rsFunction s64vector-any s64vector-every s64vector-partition s64vector-filter
syn keyword r7rsFunction s64vector-remove s64vector->list reverse-s64vector->list list->s64vector
syn keyword r7rsFunction reverse-list->s64vector s64vector->vector vector->s64vector
syn keyword r7rsFunction make-s64vector-generator s64vector-comparator write-s64vector
syn keyword r7rsFunctionM s64vector-map! s64vector-set! s64vector-swap! s64vector-fill!
syn keyword r7rsFunctionM s64vector-reverse! s64vector-copy! s64vector-reverse-copy!
syn keyword r7rsFunctionM s64vector-unfold! s64vector-unfold-right!

" u64 {{{2
syn keyword r7rsFunction make-u64vector u64vector u64vector-unfold u64vector-unfold-right
syn keyword r7rsFunction u64vector-copy u64vector-reverse-copy u64vector-append
syn keyword r7rsFunction u64vector-concatenate u64vector-append-subvectors u64? u64vector?
syn keyword r7rsFunction u64vector-empty? u64vector= u64vector-ref u64vector-length u64vector-take
syn keyword r7rsFunction u64vector-take-right u64vector-drop u64vector-drop-right u64vector-segment
syn keyword r7rsFunction u64vector-fold u64vector-fold-right u64vector-map u64vector-for-each
syn keyword r7rsFunction u64vector-count u64vector-cumulate u64vector-take-while
syn keyword r7rsFunction u64vector-take-while-right u64vector-drop-while u64vector-drop-while-right
syn keyword r7rsFunction u64vector-index u64vector-index-right u64vector-skip u64vector-skip-right
syn keyword r7rsFunction u64vector-any u64vector-every u64vector-partition u64vector-filter
syn keyword r7rsFunction u64vector-remove u64vector->list reverse-u64vector->list list->u64vector
syn keyword r7rsFunction reverse-list->u64vector u64vector->vector vector->u64vector
syn keyword r7rsFunction make-u64vector-generator u64vector-comparator write-u64vector
syn keyword r7rsFunctionM u64vector-map! u64vector-set! u64vector-swap! u64vector-fill!
syn keyword r7rsFunctionM u64vector-reverse! u64vector-copy! u64vector-reverse-copy!
syn keyword r7rsFunctionM u64vector-unfold! u64vector-unfold-right!

" f32 {{{2
syn keyword r7rsFunction make-f32vector f32vector f32vector-unfold f32vector-unfold-right
syn keyword r7rsFunction f32vector-copy f32vector-reverse-copy f32vector-append
syn keyword r7rsFunction f32vector-concatenate f32vector-append-subvectors f32? f32vector?
syn keyword r7rsFunction f32vector-empty? f32vector= f32vector-ref f32vector-length f32vector-take
syn keyword r7rsFunction f32vector-take-right f32vector-drop f32vector-drop-right f32vector-segment
syn keyword r7rsFunction f32vector-fold f32vector-fold-right f32vector-map f32vector-for-each
syn keyword r7rsFunction f32vector-count f32vector-cumulate f32vector-take-while
syn keyword r7rsFunction f32vector-take-while-right f32vector-drop-while f32vector-drop-while-right
syn keyword r7rsFunction f32vector-index f32vector-index-right f32vector-skip f32vector-skip-right
syn keyword r7rsFunction f32vector-any f32vector-every f32vector-partition f32vector-filter
syn keyword r7rsFunction f32vector-remove f32vector->list reverse-f32vector->list list->f32vector
syn keyword r7rsFunction reverse-list->f32vector f32vector->vector vector->f32vector
syn keyword r7rsFunction make-f32vector-generator f32vector-comparator write-f32vector
syn keyword r7rsFunctionM f32vector-map! f32vector-set! f32vector-swap! f32vector-fill!
syn keyword r7rsFunctionM f32vector-reverse! f32vector-copy! f32vector-reverse-copy!
syn keyword r7rsFunctionM f32vector-unfold! f32vector-unfold-right!

" f64 {{{2
syn keyword r7rsFunction make-f64vector f64vector f64vector-unfold f64vector-unfold-right
syn keyword r7rsFunction f64vector-copy f64vector-reverse-copy f64vector-append
syn keyword r7rsFunction f64vector-concatenate f64vector-append-subvectors f64? f64vector?
syn keyword r7rsFunction f64vector-empty? f64vector= f64vector-ref f64vector-length f64vector-take
syn keyword r7rsFunction f64vector-take-right f64vector-drop f64vector-drop-right f64vector-segment
syn keyword r7rsFunction f64vector-fold f64vector-fold-right f64vector-map f64vector-for-each
syn keyword r7rsFunction f64vector-count f64vector-cumulate f64vector-take-while
syn keyword r7rsFunction f64vector-take-while-right f64vector-drop-while f64vector-drop-while-right
syn keyword r7rsFunction f64vector-index f64vector-index-right f64vector-skip f64vector-skip-right
syn keyword r7rsFunction f64vector-any f64vector-every f64vector-partition f64vector-filter
syn keyword r7rsFunction f64vector-remove f64vector->list reverse-f64vector->list list->f64vector
syn keyword r7rsFunction reverse-list->f64vector f64vector->vector vector->f64vector
syn keyword r7rsFunction make-f64vector-generator f64vector-comparator write-f64vector
syn keyword r7rsFunctionM f64vector-map! f64vector-set! f64vector-swap! f64vector-fill!
syn keyword r7rsFunctionM f64vector-reverse! f64vector-copy! f64vector-reverse-copy!
syn keyword r7rsFunctionM f64vector-unfold! f64vector-unfold-right!

" c64 {{{2
syn keyword r7rsFunction make-c64vector c64vector c64vector-unfold c64vector-unfold-right
syn keyword r7rsFunction c64vector-copy c64vector-reverse-copy c64vector-append
syn keyword r7rsFunction c64vector-concatenate c64vector-append-subvectors c64? c64vector?
syn keyword r7rsFunction c64vector-empty? c64vector= c64vector-ref c64vector-length c64vector-take
syn keyword r7rsFunction c64vector-take-right c64vector-drop c64vector-drop-right c64vector-segment
syn keyword r7rsFunction c64vector-fold c64vector-fold-right c64vector-map c64vector-for-each
syn keyword r7rsFunction c64vector-count c64vector-cumulate c64vector-take-while
syn keyword r7rsFunction c64vector-take-while-right c64vector-drop-while c64vector-drop-while-right
syn keyword r7rsFunction c64vector-index c64vector-index-right c64vector-skip c64vector-skip-right
syn keyword r7rsFunction c64vector-any c64vector-every c64vector-partition c64vector-filter
syn keyword r7rsFunction c64vector-remove c64vector->list reverse-c64vector->list list->c64vector
syn keyword r7rsFunction reverse-list->c64vector c64vector->vector vector->c64vector
syn keyword r7rsFunction make-c64vector-generator c64vector-comparator write-c64vector
syn keyword r7rsFunctionM c64vector-map! c64vector-set! c64vector-swap! c64vector-fill!
syn keyword r7rsFunctionM c64vector-reverse! c64vector-copy! c64vector-reverse-copy!
syn keyword r7rsFunctionM c64vector-unfold! c64vector-unfold-right!

" c128 {{{2
syn keyword r7rsFunction make-c128vector c128vector c128vector-unfold c128vector-unfold-right
syn keyword r7rsFunction c128vector-copy c128vector-reverse-copy c128vector-append
syn keyword r7rsFunction c128vector-concatenate c128vector-append-subvectors c128? c128vector?
syn keyword r7rsFunction c128vector-empty? c128vector= c128vector-ref c128vector-length c128vector-take
syn keyword r7rsFunction c128vector-take-right c128vector-drop c128vector-drop-right c128vector-segment
syn keyword r7rsFunction c128vector-fold c128vector-fold-right c128vector-map c128vector-for-each
syn keyword r7rsFunction c128vector-count c128vector-cumulate c128vector-take-while
syn keyword r7rsFunction c128vector-take-while-right c128vector-drop-while c128vector-drop-while-right
syn keyword r7rsFunction c128vector-index c128vector-index-right c128vector-skip c128vector-skip-right
syn keyword r7rsFunction c128vector-any c128vector-every c128vector-partition c128vector-filter
syn keyword r7rsFunction c128vector-remove c128vector->list reverse-c128vector->list list->c128vector
syn keyword r7rsFunction reverse-list->c128vector c128vector->vector vector->c128vector
syn keyword r7rsFunction make-c128vector-generator c128vector-comparator write-c128vector
syn keyword r7rsFunctionM c128vector-map! c128vector-set! c128vector-swap! c128vector-fill!
syn keyword r7rsFunctionM c128vector-reverse! c128vector-copy! c128vector-reverse-copy!
syn keyword r7rsFunctionM c128vector-unfold! c128vector-unfold-right!

" (scheme sort) SRFI 132 {{{1
syn keyword r7rsFunction list-sorted? vector-sorted?
syn keyword r7rsFunction list-sort list-stable-sort vector-sort vector-stable-sort
syn keyword r7rsFunction list-merge vector-merge list-delete-neighbor-dups vector-delete-neighbor-dups
syn keyword r7rsFunction vector-find-median 
syn keyword r7rsFunctionM list-sort! list-stable-sort! vector-sort! vector-stable-sort!
syn keyword r7rsFunctionM list-merge! vector-merge! list-delete-neighbor-dups! vector-delete-neighbor-dups!
syn keyword r7rsFunctionM vector-find-median! vector-select! vector-separate!

" (scheme set) SRFI 113 {{{1
syn keyword r7rsFunction set set-unfold
syn keyword r7rsFunction bag bag-unfold
syn keyword r7rsFunction set? set-contains? set-empty? set-disjoint?
syn keyword r7rsFunction bag? bag-contains? bag-empty? bag-disjoint?
syn keyword r7rsFunction set-member set-element-comparator
syn keyword r7rsFunction bag-member bag-element-comparator
syn keyword r7rsFunction set-adjoin set-replace set-delete set-delete-all
syn keyword r7rsFunction bag-adjoin bag-replace bag-delete bag-delete-all
syn keyword r7rsFunctionM set-adjoin! set-replace! set-delete! set-delete-all! set-search!
syn keyword r7rsFunctionM bag-adjoin! bag-replace! bag-delete! bag-delete-all! bag-search!
syn keyword r7rsFunction set-size set-find set-count set-any? set-every?
syn keyword r7rsFunction bag-size bag-find bag-count bag-any? bag-every?
syn keyword r7rsFunction set-map set-for-each set-fold set-filter set-remove set-partition
syn keyword r7rsFunction bag-map bag-for-each bag-fold bag-filter bag-remove bag-partition
syn keyword r7rsFunctionM set-filter! set-remove! set-partition!
syn keyword r7rsFunctionM bag-filter! bag-remove! bag-partition!
syn keyword r7rsFunction set-copy set->list list->set
syn keyword r7rsFunction bag-copy bag->list list->bag
syn keyword r7rsFunctionM list->set!
syn keyword r7rsFunctionM list->bag!
syn keyword r7rsFunction set=? set<? set>? set<=? set>=?
syn keyword r7rsFunction bag=? bag<? bag>? bag<=? bag>=?
syn keyword r7rsFunction set-union set-intersection set-difference set-xor
syn keyword r7rsFunction bag-union bag-intersection bag-difference bag-xor
syn keyword r7rsFunctionM set-union! set-intersection! set-difference! set-xor!
syn keyword r7rsFunctionM bag-union! bag-intersection! bag-difference! bag-xor!
syn keyword r7rsFunction bag-sum bag-product
syn keyword r7rsFunctionM bag-sum! bag-product! bag-increment! bag-decrement!
syn keyword r7rsFunction bag-unique-size bag-element-count bag-for-each-unique bag-fold-unique
syn keyword r7rsFunction bag->set set->bag bag->alist alist->bag
syn keyword r7rsFunctionM set->bag!
syn keyword r7rsVariable set-comparator bag-comparator

" (scheme charset) SRFI 14 {{{1
syn keyword r7rsFunction char-set? char-set= char-set<= char-set-hash
syn keyword r7rsFunction char-set-cursor char-set-ref char-set-cursor-next end-of-char-set? 
syn keyword r7rsFunction char-set-fold char-set-unfold char-set-for-each char-set-map
syn keyword r7rsFunctionM char-set-unfold!
syn keyword r7rsFunction char-set-copy char-set ->char-set
syn keyword r7rsFunction list->char-set string->char-set char-set-filter ucs-range->char-set
syn keyword r7rsFunctionM list->char-set! string->char-set! char-set-filter! ucs-range->char-set!
syn keyword r7rsFunction char-set->list char-set->string char-set-size char-set-count char-set-contains?
syn keyword r7rsFunction char-set-every char-set-any
syn keyword r7rsFunction char-set-adjoin char-set-delete char-set-complement char-set-union
syn keyword r7rsFunctionM char-set-adjoin! char-set-delete! char-set-complement! char-set-union!
syn keyword r7rsFunction char-set-intersection char-set-difference char-set-xor
syn keyword r7rsFunctionM char-set-intersection! char-set-difference! char-set-xor!
syn keyword r7rsFunction char-set-diff+intersection
syn keyword r7rsFunctionM char-set-diff+intersection!
syn keyword r7rsVariable char-set:lower-case char-set:upper-case char-set:title-case char-set:letter
syn keyword r7rsVariable char-set:digit char-set:letter+digit char-set:graphic char-set:printing
syn keyword r7rsVariable char-set:whitespace char-set:iso-control char-set:punctuation char-set:symbol
syn keyword r7rsVariable char-set:hex-digit char-set:blank char-set:ascii char-set:empty char-set:full

" (scheme hash-table) SRFI 125 {{{1
syn keyword r7rsFunction make-hash-table hash-table hash-table-unfold alist->hash-table hash-table?
syn keyword r7rsFunction hash-table-contains? hash-table-empty? hash-table=? hash-table-mutable?
syn keyword r7rsFunction hash-table-ref hash-table-ref/default
syn keyword r7rsFunctionM hash-table-set! hash-table-delete! hash-table-intern! hash-table-update!
syn keyword r7rsFunctionM hash-table-update!/default hash-table-pop! hash-table-clear! 
syn keyword r7rsFunction hash-table-size hash-table-keys hash-table-values hash-table-entries
syn keyword r7rsFunction hash-table-find hash-table-count 
syn keyword r7rsFunction hash-table-map hash-table-for-each hash-table-map->list hash-table-fold
syn keyword r7rsFunctionM hash-table-map! hash-table-prune! 
syn keyword r7rsFunction hash-table-copy hash-table-empty-copy hash-table->alist 
syn keyword r7rsFunctionM hash-table-union! hash-table-intersection! hash-table-difference!
syn keyword r7rsFunctionM hash-table-xor!

" (scheme ilist) SRFI 116 {{{1
syn keyword r7rsFunction ipair ilist xipair ipair* make-ilist ilist-tabulate ilist-copy iiota
syn keyword r7rsFunction ipair? proper-ilist? ilist? dotted-ilist? not-ipair? null-ilist? ilist=
syn keyword r7rsFunction icar icdr icaar icdar icadr icddr
syn keyword r7rsFunction icaaar icdaar icadar icddar icaadr icdadr icaddr icdddr
syn keyword r7rsFunction icaaaar icdaaar icadaar icddaar icaadar icdadar icaddar icdddar
syn keyword r7rsFunction icaaadr icdaadr icadadr icddadr icaaddr icdaddr icadddr icddddr ilist-ref
syn keyword r7rsFunction ifirst isecond ithird ifourth ififth isixth iseventh ieighth ininth itenth
syn keyword r7rsFunction icar+icdr itake idrop ilist-tail itake-right idrop-right isplit-at
syn keyword r7rsFunction ilast last-ipair ilength iappend iconcatenate ireverse iappend-reverse
syn keyword r7rsFunction izip iunzip1 iunzip2 iunzip3 iunzip4 iunzip5 icount
syn keyword r7rsFunction imap ifor-each ifold iunfold ipair-fold ireduce ifold-right iunfold-right
syn keyword r7rsFunction ipair-fold-right ireduce-right iappend-map ipair-for-each ifilter-map
syn keyword r7rsFunction imap-in-order
syn keyword r7rsFunction ifilter ipartition iremove
syn keyword r7rsFunction imember imemq imemv ifind ifind-tail iany ievery ilist-index
syn keyword r7rsFunction itake-while idrop-while ispan ibreak idelete idelete-duplicates
syn keyword r7rsFunction iassoc iassq iassv ialist-cons ialist-delete
syn keyword r7rsFunction replace-icar replace-icdr pair->ipair ipair->pair list->ilist
syn keyword r7rsFunction ilist->list tree->itree itree->tree gtree->itree gtree->tree iapply
syn keyword r7rsFunction make-ilist-comparator make-improper-ilist-comparator
syn keyword r7rsFunction make-icar-comparator make-icdr-comparator
syn keyword r7rsVariable ipair-comparator ilist-comparator

" (scheme rlist) SRFI 101 {{{1
syn keyword r7rsFunction list-set list-ref/update random-access-list->linear-access-list
syn keyword r7rsFunction linear-access-list->random-access-list

" (scheme ideque) SRFI 134 {{{1
syn keyword r7rsFunction ideque ideque-tabulate ideque-unfold ideque-unfold-right
syn keyword r7rsFunction ideque? ideque-empty? ideque= ideque-any ideque-every
syn keyword r7rsFunction ideque-front ideque-back ideque-remove-front ideque-remove-back
syn keyword r7rsFunction ideque-add-front ideque-add-back
syn keyword r7rsFunction ideque-ref ideque-take ideque-take-right ideque-drop ideque-drop-right
syn keyword r7rsFunction ideque-split-at
syn keyword r7rsFunction ideque-length ideque-append ideque-reverse ideque-count ideque-zip
syn keyword r7rsFunction ideque-map ideque-filter-map ideque-for-each ideque-for-each-right
syn keyword r7rsFunction ideque-fold ideque-fold-right ideque-append-map
syn keyword r7rsFunction ideque-filter ideque-remove ideque-partition
syn keyword r7rsFunction ideque-find ideque-find-right ideque-take-while ideque-take-while-right
syn keyword r7rsFunction ideque-drop-while ideque-drop-while-right ideque-span ideque-break
syn keyword r7rsFunction list->ideque ideque->list generator->ideque ideque->generator

" (scheme text) SRFI 135 {{{1
syn keyword r7rsFunction text? textual? textual-null? textual-every textual-any
syn keyword r7rsFunction make-text text text-tabulate text-unfold text-unfold-right
syn keyword r7rsFunction textual->text textual->string textual->vector textual->list string->text
syn keyword r7rsFunction vector->text list->text reverse-list->text textual->utf8 textual->utf16
syn keyword r7rsFunction textual->utf16be textual->utf16le utf8->text utf16->text utf16be->text
syn keyword r7rsFunction utf16le->text
syn keyword r7rsFunction text-length text-ref textual-length textual->ref subtext subtextual
syn keyword r7rsFunction textual-copy textual-take textual-drop textual-take-right
syn keyword r7rsFunction textual-drop-right textual-pad textual-pad-right textual-trim
syn keyword r7rsFunction textual-trim-right textual-trim-both textual-replace
syn keyword r7rsFunction textual=? textual<? textual>? textual<=? textual>=?
syn keyword r7rsFunction textual-ci=? textual-ci<? textual-ci>? textual-ci<=? textual-ci>=?
syn keyword r7rsFunction textual-prefix-length textual-suffix-length textual-prefix? textual-suffix?
syn keyword r7rsFunction textual-index textual-index-right textual-skip textual-skip-right
syn keyword r7rsFunction textual-contains textual-contains-right
syn keyword r7rsFunction textual-upcase textual-downcase textual-foldcase textual-titlecase
syn keyword r7rsFunction textual-append textual-concatenate textual-concatenate-reverse textual-join
syn keyword r7rsFunction textual-fold textual-fold-right textual-map textual-for-each
syn keyword r7rsFunction textual-map-index textual-for-each-index textual-count textual-filter
syn keyword r7rsFunction textual-remove textual-replicate textual-split

" (scheme generator) SRFI 158 {{{1
syn keyword r7rsFunction generator circular-generator make-iota-generator make-range-generator
syn keyword r7rsFunction make-coroutine-generator make-for-each-generator make-unfold-generator
syn keyword r7rsFunction list->generator vector->generator
syn keyword r7rsFunction reverse-vector->generator string->generator bytevector->generator
syn keyword r7rsFunction gcons* gappend gflatten ggroup gmerge gmap gcombine gfilter gremove
syn keyword r7rsFunction gstate-filter gtake gdrop gtake-while gdrop-while gdelete
syn keyword r7rsFunction gdelete-neighbor-dups gindex gselect
syn keyword r7rsFunction generator->list generator->reverse-list generator->vector
syn keyword r7rsFunction generator->string generator-fold generator-for-each generator-map->list
syn keyword r7rsFunction generator-find generator-count generator-any generator-every
syn keyword r7rsFunction generator-unfold
syn keyword r7rsFunction make-accumulator count-accumulator list-accumulator
syn keyword r7rsFunction reverse-list-accumulator vector-accumulator
syn keyword r7rsFunction reverse-vector-accumulator string-accumulator bytevector-accumulator
syn keyword r7rsFunction sum-accumulator product-accumulator
syn keyword r7rsFunctionM generator->vector! vector-accumulator! bytevector-accumulator!

" (scheme lseq) SRFI 127 {{{1
syn keyword r7rsFunction generator->lseq lseq? lseq=?
syn keyword r7rsFunction lseq-car lseq-cdr lseq-first lseq-rest lseq-ref lseq-take lseq-drop 
syn keyword r7rsFunction lseq-realize lseq->generator lseq-length lseq-append lseq-zip
syn keyword r7rsFunction lseq-map lseq-for-each lseq-filter lseq-remove
syn keyword r7rsFunction lseq-find lseq-find-tail lseq-any lseq-every lseq-index lseq-take-while
syn keyword r7rsFunction lseq-drop-while lseq-member lseq-memq lseq-memv 

" (scheme stream) SRFI 41 {{{1
syn keyword r7rsSyntaxM define-stream
syn keyword r7rsSyntax stream-cons stream-lambda stream stream-let stream-match stream-of
syn keyword r7rsVariable stream-null
syn keyword r7rsFunction stream? stream-null? stream-pair? stream-car stream-cdr
syn keyword r7rsFunction list->stream port->stream stream->list stream-append stream-concat
syn keyword r7rsFunction stream-constant stream-drop stream-drop-while stream-filter stream-fold
syn keyword r7rsFunction stream-for-each stream-from stream-iterate stream-length stream-map
syn keyword r7rsFunction stream-range stream-ref stream-reverse stream-scan stream-take
syn keyword r7rsFunction stream-take-while stream-unfold stream-unfolds stream-zip

" (scheme box) SRFI 111 {{{1
syn keyword r7rsFunction box box? unbox
syn keyword r7rsFunctionM set-box!

" (scheme list-queue) SRFI 117 {{{1
syn keyword r7rsFunction make-list-queue list-queue list-queue-copy list-queue-unfold
syn keyword r7rsFunction list-queue-unfold-right list-queue? list-queue-empty?
syn keyword r7rsFunction list-queue-front list-queue-back list-queue-list list-queue-first-last
syn keyword r7rsFunction list-queue-append list-queue-concatenate list-queue-map list-queue-for-each
syn keyword r7rsFunctionM list-queue-add-front! list-queue-add-back! list-queue-remove-front!
syn keyword r7rsFunctionM list-queue-remove-back! list-queue-remove-all! list-queue-set-list!
syn keyword r7rsFunctionM list-queue-append! list-queue-map!

" (scheme ephemeron) SRFI 124 {{{1
syn keyword r7rsFunction ephemeron? make-ephemeron ephemeron-broken? ephemeron-key ephemeron-datum
syn keyword r7rsFunction reference-barrier

" (scheme comparator) SRFI 128 {{{1
syn keyword r7rsSyntax comparator-if<=>
syn keyword r7rsFunction comparator? comparator-ordered? comparator-hashable?
syn keyword r7rsFunction make-comparator make-pair-comparator make-list-comparator
syn keyword r7rsFunction make-vector-comparator make-eq-comparator make-eqv-comparator
syn keyword r7rsFunction make-equal-comparator
syn keyword r7rsFunction boolean-hash char-hash char-ci-hash string-hash string-ci-hash symbol-hash
syn keyword r7rsFunction number-hash hash-bound hash-salt
syn keyword r7rsFunction make-default-comparator default-hash
syn keyword r7rsFunction comparator-type-test-predicate comparator-equality-predicate
syn keyword r7rsFunction comparator-ordering-predicate comparator-hash-function comparator-test-type
syn keyword r7rsFunction comparator-check-type comparator-hash
syn keyword r7rsFunction =? <? >? <=? >=?
syn keyword r7rsFunctionM comparator-register-default!

" (scheme mapping) SRFI 146 {{{1
syn keyword r7rsFunction mapping mapping-unfold mapping/ordered mapping-unfold/ordered
syn keyword r7rsFunction mapping? mapping-contains? mapping-empty? mapping-disjoint?
syn keyword r7rsFunction mapping-ref mapping-ref/default mapping-key-comparator
syn keyword r7rsFunction mapping-adjoin mapping-set mapping-replace mapping-delete
syn keyword r7rsFunctionM mapping-adjoin! mapping-set! mapping-replace! mapping-delete!
syn keyword r7rsFunction mapping-delete-all mapping-intern mapping-update
syn keyword r7rsFunctionM mapping-delete-all! mapping-intern! mapping-update!
syn keyword r7rsFunction mapping-update/default mapping-pop mapping-search
syn keyword r7rsFunctionM mapping-update!/default mapping-pop! mapping-search!
syn keyword r7rsFunction mapping-size mapping-find mapping-count mapping-any? mapping-every?
syn keyword r7rsFunction mapping-keys mapping-values mapping-entries
syn keyword r7rsFunction mapping-map mapping-map->list mapping-for-each mapping-fold
syn keyword r7rsFunction mapping-filter mapping-remove mapping-partition
syn keyword r7rsFunctionM mapping-filter! mapping-remove! mapping-partition!
syn keyword r7rsFunction mapping-copy mapping->alist alist->mapping alist->mapping/ordered
syn keyword r7rsFunctionM alist->mapping! alist->mapping/ordered!
syn keyword r7rsFunction mapping=? mapping<? mapping>? mapping<=? mapping>=?
syn keyword r7rsFunction mapping-union mapping-intersection mapping-difference mapping-xor
syn keyword r7rsFunctionM mapping-union! mapping-intersection! mapping-difference! mapping-xor!
syn keyword r7rsFunction mapping-min-key mapping-max-key mapping-min-value mapping-max-value
syn keyword r7rsFunction mapping-min-entry mapping-max-entry mapping-key-predecessor mapping-key-successor
syn keyword r7rsFunction mapping-range= mapping-range< mapping-range> mapping-range<= mapping-range>=
syn keyword r7rsFunctionM mapping-range=! mapping-range<! mapping-range>! mapping-range<=! mapping-range>=!
syn keyword r7rsFunction mapping-split mapping-catenate mapping-map/monotone mapping-fold/reverse
syn keyword r7rsFunctionM mapping-split! mapping-catenate! mapping-map/monotone!
syn keyword r7rsFunction make-mapping-comparator
syn keyword r7rsVariable mapping-comparator


" (scheme mapping hash) SRFI 146 {{{1
syn keyword r7rsFunction hashmap hashmap-unfold hashmap/ordered hashmap-unfold/ordered
syn keyword r7rsFunction hashmap? hashmap-contains? hashmap-empty? hashmap-disjoint?
syn keyword r7rsFunction hashmap-ref hashmap-ref/default hashmap-key-comparator
syn keyword r7rsFunction hashmap-adjoin hashmap-set hashmap-replace hashmap-delete
syn keyword r7rsFunctionM hashmap-adjoin! hashmap-set! hashmap-replace! hashmap-delete!
syn keyword r7rsFunction hashmap-delete-all hashmap-intern hashmap-update
syn keyword r7rsFunctionM hashmap-delete-all! hashmap-intern! hashmap-update!
syn keyword r7rsFunction hashmap-update/default hashmap-pop hashmap-search
syn keyword r7rsFunctionM hashmap-update!/default hashmap-pop! hashmap-search!
syn keyword r7rsFunction hashmap-size hashmap-find hashmap-count hashmap-any? hashmap-every?
syn keyword r7rsFunction hashmap-keys hashmap-values hashmap-entries
syn keyword r7rsFunction hashmap-map hashmap-map->list hashmap-for-each hashmap-fold
syn keyword r7rsFunction hashmap-filter hashmap-remove hashmap-partition
syn keyword r7rsFunctionM hashmap-filter! hashmap-remove! hashmap-partition!
syn keyword r7rsFunction hashmap-copy hashmap->alist alist->hashmap alist->hashmap/ordered
syn keyword r7rsFunctionM alist->hashmap! alist->hashmap/ordered!
syn keyword r7rsFunction hashmap=? hashmap<? hashmap>? hashmap<=? hashmap>=?
syn keyword r7rsFunction hashmap-union hashmap-intersection hashmap-difference hashmap-xor
syn keyword r7rsFunctionM hashmap-union! hashmap-intersection! hashmap-difference! hashmap-xor!
syn keyword r7rsFunction hashmap-min-key hashmap-max-key hashmap-min-value hashmap-max-value
syn keyword r7rsFunction hashmap-min-entry hashmap-max-entry hashmap-key-predecessor hashmap-key-successor
syn keyword r7rsFunction hashmap-range= hashmap-range< hashmap-range> hashmap-range<= hashmap-range>=
syn keyword r7rsFunctionM hashmap-range=! hashmap-range<! hashmap-range>! hashmap-range<=! hashmap-range>=!
syn keyword r7rsFunction hashmap-split hashmap-catenate hashmap-map/monotone hashmap-fold/reverse
syn keyword r7rsFunctionM hashmap-split! hashmap-catenate! hashmap-map/monotone!
syn keyword r7rsFunction make-hashmap-comparator
syn keyword r7rsVariable hashmap-comparator

" (scheme regex) SRFI 115 {{{1
syn keyword r7rsSyntax rx
syn keyword r7rsFunction regexp regexp->sre char-set->sre valid-sre? regexp? regexp-match?
syn keyword r7rsFunction regexp-matches regexp-matches? regexp-search regexp-fold regexp-extract
syn keyword r7rsFunction regexp-split regexp-partition regexp-replace regexp-replace-all
syn keyword r7rsFunction regexp-match-submatch regexp-match-submatch-start regexp-match-submatch-end
syn keyword r7rsFunction regexp-match-count regexp-match->list

" (scheme division) SRFI 141 {{{1
" `floor` and `truncate` families are part of R7RS-small.
" syn keyword r7rsFunction floor/ floor-quotient floor-remainder
" syn keyword r7rsFunction truncate/ truncate-quotient truncate-remainder
syn keyword r7rsFunction ceiling/ ceiling-quotient ceiling-remainder
syn keyword r7rsFunction round/ round-quotient round-remainder
syn keyword r7rsFunction euclidean/ euclidean-quotient euclidean-remainder
syn keyword r7rsFunction balanced/ balanced-quotient balanced-remainder

" (scheme bitwise) SRFI 151 {{{1
syn keyword r7rsFunction bitwise-not bitwise-and bitwise-ior bitwise-xor bitwise-eqv bitwise-nand
syn keyword r7rsFunction bitwise-nor bitwise-andc1 bitwise-andc2 bitwise-orc1 bitwise-orc2 
syn keyword r7rsFunction arithmetic-shift bit-count integer-length bitwise-if
syn keyword r7rsFunction bit-set? copy-bit bit-swap any-bit-set? every-bit-set? first-set-bit
syn keyword r7rsFunction bit-field bit-field-any? bit-field-every? bit-field-clear bit-field-set
syn keyword r7rsFunction bit-field-replace bit-field-replace-same bit-field-rotate bit-field-reverse
syn keyword r7rsFunction bits->list list->bits bits->vector vector->bits bits
syn keyword r7rsFunction bitwise-fold bitwise-for-each bitwise-unfold make-bitwise-generator

" (scheme fixnum) SRFI 143 {{{1
syn keyword r7rsFunction fx-width fx-greatest fx-least fixnum? fx=? fx<? fx>? fx<=? fx>=?
syn keyword r7rsFunction fxzero? fxpositive? fxnegative? fxodd? fxeven? fxmax fxmin
syn keyword r7rsFunction fx+ fx- fxneg fx* fxquotient fxremainder fxabs fxsquare fxsqrt
syn keyword r7rsFunction fx+/carry fx-/carry fx*/carry
syn keyword r7rsFunction fxnot fxand fxior fxxor
syn keyword r7rsFunction fxarithmetic-shift fxarithmetic-shift-left fxarithmetic-shift-right
syn keyword r7rsFunction fxbit-count fxlength fxif fxbit-set?
syn keyword r7rsFunction fxcopy-bit fxfirst-set-bit fxbit-field fxbit-field-rotate
syn keyword r7rsFunction fxbit-field-reverse

" (scheme flonum) SRFI 144 {{{1
syn keyword r7rsConstant fl-e fl-1/e fl-e-2 fl-e-pi/4 fl-log2-e fl-log10-e fl-log-2 fl-1/log-2
syn keyword r7rsConstant fl-log-3 fl-log-pi fl-log-10 fl-1/log-10 fl-pi fl-1/pi fl-2pi fl-pi/2
syn keyword r7rsConstant fl-pi/4 fl-pi-squared fl-degree fl-2/pi fl-2/sqrt-pi fl-sqrt-2 fl-sqrt-3
syn keyword r7rsConstant fl-sqrt-5 fl-sqrt-10 fl-1/sqrt-2 fl-cbrt-2 fl-cbrt-3 fl-4thrt-2
syn keyword r7rsConstant fl-phi fl-log-phi fl-1/log-phi fl-euler fl-e-euler
syn keyword r7rsConstant fl-sin-1 fl-cos-1 fl-gamma-1/2 fl-gamma-1/3 fl-gamma-2/3
syn keyword r7rsConstant fl-greatest fl-least fl-epsilon fl-fast-fl+*
syn keyword r7rsConstant fl-integer-exponent-zero fl-integer-exponent-nan
syn keyword r7rsFunction flonum fladjacent flcopysign make-flonum
syn keyword r7rsFunction flinteger-fraction flexponent flinteger-exponent
syn keyword r7rsFunction flnormalized-fraction-exponent flsign-bit
syn keyword r7rsFunction flonum? fl=? fl<? fl>? fl<=? fl>=? flunordered? flinteger? flzero?
syn keyword r7rsFunction flpositive? flnegative? flodd? fleven? flfinite? flinfinite? flnan?
syn keyword r7rsFunction flnormalized? fldenormalized?
syn keyword r7rsFunction flmax flmin fl+ fl* fl+* fl- fl/ flabs flabsdiff flposdiff flsgn
syn keyword r7rsFunction flnumerator fldenominator flfloor flceiling flround fltruncate
syn keyword r7rsFunction flexp flexp2 flexp-1 flsquare flsqrt flcbrt flhypot flexpt fllog fllog1+
syn keyword r7rsFunction fllog2 fllog10 make-fllog-base
syn keyword r7rsFunction flsin flcos fltan flasin flacos flatan flsinh flcosh fltanh
syn keyword r7rsFunction flasinh flacosh flatanh flquotient flremainder flremquo
syn keyword r7rsFunction flgamma flloggamma flfirst-bessel flsecond-bessel flerf flerfc

" (scheme bytevector) R6RS {{{1
syn keyword r7rsSyntax endianness
syn keyword r7rsFunction native-endianness bytevector=?
syn keyword r7rsFunctionM bytevector-fill!
syn keyword r7rsFunction bytevector-s8-ref bytevector->u8-list u8-list->bytevector
syn keyword r7rsFunctionM bytevector-s8-set!
syn keyword r7rsFunction bytevector-uint-ref bytevector-sint-ref
syn keyword r7rsFunctionM bytevector-uint-set! bytevector-sint-set!
syn keyword r7rsFunction bytevector->uint-list bytevector->sint-list
syn keyword r7rsFunction uint-list->bytevector sint-list->bytevector
syn keyword r7rsFunction bytevector-u16-ref bytevector-s16-ref
syn keyword r7rsFunction bytevector-u16-native-ref bytevector-s16-native-ref
syn keyword r7rsFunctionM bytevector-u16-set! bytevector-s16-set!
syn keyword r7rsFunctionM bytevector-u16-native-set! bytevector-s16-native-set!
syn keyword r7rsFunction bytevector-u32-ref bytevector-s32-ref
syn keyword r7rsFunction bytevector-u32-native-ref bytevector-s32-native-ref
syn keyword r7rsFunctionM bytevector-u32-set! bytevector-s32-set!
syn keyword r7rsFunctionM bytevector-u32-native-set! bytevector-s32-native-set!
syn keyword r7rsFunction bytevector-u64-ref bytevector-s64-ref
syn keyword r7rsFunction bytevector-u64-native-ref bytevector-s64-native-ref
syn keyword r7rsFunctionM bytevector-u64-set! bytevector-s64-set!
syn keyword r7rsFunctionM bytevector-u64-native-set! bytevector-s64-native-set!
syn keyword r7rsFunction bytevector-ieee-single-ref bytevector-ieee-double-ref
syn keyword r7rsFunction bytevector-ieee-single-native-ref bytevector-ieee-double-native-ref
syn keyword r7rsFunctionM bytevector-ieee-single-set! bytevector-ieee-double-set!
syn keyword r7rsFunctionM bytevector-ieee-single-native-set! bytevector-ieee-double-native-set!
syn keyword r7rsFunction string->utf16 string->utf32 utf16->string utf32->string

" Highlights {{{1

hi def link r7rsVariable Identifier

" }}}

" vim: et sw=2 sts=-1 tw=100 fdm=marker

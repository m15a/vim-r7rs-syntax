" Vim syntax file
" Language: Scheme (R7RS)
" Last Change: 2020-06-22
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if !exists('b:did_r7rs_syntax')
  finish
endif

" (scheme list) SRFI-1 {{{1
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

" (scheme vector) SRFI-133 {{{1
syn keyword r7rsFunction vector-unfold vector-unfold-right vector-reverse-copy vector-concatenate
syn keyword r7rsFunction vector-append-subvectors vector-empty? vector=
syn keyword r7rsFunction vector-fold vector-fold-right vector-map! vector-count vector-cumulate
syn keyword r7rsFunction vector-index vector-index-right vector-skip vector-skip-right
syn keyword r7rsFunction vector-binary-search vector-any vector-every vector-partition
syn keyword r7rsFunction reverse-vector->list reverse-list->vector
syn keyword r7rsFunctionM vector-swap! vector-reverse! vector-reverse-copy! vector-unfold!
syn keyword r7rsFunctionM vector-unfold-right!

" (scheme vector @) SRFI-160 {{{1
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

" (scheme sort) SRFI-132 {{{1
syn keyword r7rsFunction list-sorted? vector-sorted?
syn keyword r7rsFunction list-sort list-stable-sort vector-sort vector-stable-sort
syn keyword r7rsFunction list-merge vector-merge list-delete-neighbor-dups vector-delete-neighbor-dups
syn keyword r7rsFunction vector-find-median 
syn keyword r7rsFunctionM list-sort! list-stable-sort! vector-sort! vector-stable-sort!
syn keyword r7rsFunctionM list-merge! vector-merge! list-delete-neighbor-dups! vector-delete-neighbor-dups!
syn keyword r7rsFunctionM vector-find-median! vector-select! vector-separate!

" (scheme set) SRFI-113 {{{1
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

" (scheme charset) SRFI-14 {{{1
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

" (scheme hash-table) SRFI-125 {{{1
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

" (scheme ideque) SRFI-134 {{{1
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

" (scheme generator) SRFI-158 {{{1
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

" (scheme box) SRFI-111 {{{1
syn keyword r7rsFunction box box? unbox
syn keyword r7rsFunctionM set-box!

" (scheme comparator) SRFI-128 {{{1
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

" Highlights {{{1

hi def link r7rsVariable Identifier

" }}}

" vim: et sw=2 sts=-1 tw=100 fdm=marker

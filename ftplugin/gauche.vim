" Vim filetype plugin file
" Language: Scheme (Gauche)
" Last change: 2020-05-26
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche
" License: Public domain
" Notes: To enable this plugin, set filetype=scheme and (b|g):is_gauche=1.

if !exists('b:did_scheme_ftplugin')
  finish
endif

" lispwords {{{

setl lispwords+=and-let*
setl lispwords+=and-let1
setl lispwords+=array-set!
setl lispwords+=assoc-set!
setl lispwords+=assq-set!
setl lispwords+=assv-set!
setl lispwords+=blob-s16-native-set!
setl lispwords+=blob-s16-set!
setl lispwords+=blob-s32-native-set!
setl lispwords+=blob-s32-set!
setl lispwords+=blob-s64-native-set!
setl lispwords+=blob-s64-set!
setl lispwords+=blob-s8-set!
setl lispwords+=blob-sint-set!
setl lispwords+=blob-u16-native-set!
setl lispwords+=blob-u16-set!
setl lispwords+=blob-u32-native-set!
setl lispwords+=blob-u32-set!
setl lispwords+=blob-u64-native-set!
setl lispwords+=blob-u64-set!
setl lispwords+=blob-u8-set!
setl lispwords+=blob-uint-set!
setl lispwords+=c128vector-set!
setl lispwords+=c32vector-set!
setl lispwords+=c64vector-set!
setl lispwords+=cf-define
setl lispwords+=class-slot-set!
setl lispwords+=condition-variable-specific-set!
setl lispwords+=define-cise-expr
setl lispwords+=define-cise-macro
setl lispwords+=define-cise-stmt
setl lispwords+=define-cise-toplevel
setl lispwords+=define-class
setl lispwords+=define-condition-type
setl lispwords+=define-constant
setl lispwords+=define-dict-interface
setl lispwords+=define-generic
setl lispwords+=define-in-module
setl lispwords+=define-inline
setl lispwords+=define-macro
setl lispwords+=define-method
setl lispwords+=define-module
setl lispwords+=define-reader-ctor
setl lispwords+=define-stream
setl lispwords+=do-ec
setl lispwords+=do-generator
setl lispwords+=do-pipeline
setl lispwords+=do-process
setl lispwords+=do-process!
setl lispwords+=dolist
setl lispwords+=dotimes
setl lispwords+=dynamic-lambda
setl lispwords+=ecase
setl lispwords+=f16vector-set!
setl lispwords+=f32vector-set!
setl lispwords+=f64vector-set!
setl lispwords+=fluid-let
setl lispwords+=glet*
setl lispwords+=glet1
setl lispwords+=hash-table-set!
setl lispwords+=hashmap-set!
setl lispwords+=if-let1
setl lispwords+=let-args
setl lispwords+=let-keywords
setl lispwords+=let-keywords*
setl lispwords+=let-optionals*
setl lispwords+=let-string-start+end
setl lispwords+=let/cc
setl lispwords+=let1
setl lispwords+=mapping-set!
setl lispwords+=match
setl lispwords+=match-define
setl lispwords+=match-lambda
setl lispwords+=match-lambda*
setl lispwords+=match-let
setl lispwords+=match-let*
setl lispwords+=match-let1
setl lispwords+=match-letrec
setl lispwords+=mutex-specific-set!
setl lispwords+=random-source-state-set!
setl lispwords+=ring-buffer-set!
setl lispwords+=rlet1
setl lispwords+=rxmatch-case
setl lispwords+=rxmatch-let
setl lispwords+=s16vector-set!
setl lispwords+=s32vector-set!
setl lispwords+=s64vector-set!
setl lispwords+=s8vector-set!
setl lispwords+=set!-values
setl lispwords+=slot-set!
setl lispwords+=sparse-matrix-set!
setl lispwords+=sparse-table-set!
setl lispwords+=sparse-vector-set!
setl lispwords+=stream-lambda
setl lispwords+=stream-let
setl lispwords+=stream-match
setl lispwords+=string-byte-set!
setl lispwords+=sys-fdset-set!
setl lispwords+=thread-specific-set!
setl lispwords+=trie-longest-match
setl lispwords+=u16vector-set!
setl lispwords+=u32vector-set!
setl lispwords+=u64vector-set!
setl lispwords+=u8vector-set!
setl lispwords+=uvector-set!
setl lispwords+=weak-vector-set!
setl lispwords+=zstream-params-set!

" }}}

" vim: et sw=2 sts=-1 tw=0 fdm=marker

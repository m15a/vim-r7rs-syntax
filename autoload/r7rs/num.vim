" Helper functions for r7rs-syntax plugin
" Last Change: 2020-06-09
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

" Build regexp of real number
fun! r7rs#num#real(digit) abort
  let l:radix = s:radix(a:digit)
  let l:prefix = l:radix ==# 'd' ? s:maybe_prefix(l:radix) : s:prefix(l:radix)
  let l:ureal = s:ureal(a:digit, l:radix)
  let l:real = s:with_infnan('[+-]\?' . l:ureal)
  return s:bless(l:prefix . l:real)
endfun

" Build regexp of complex number (rectangular notation)
fun! r7rs#num#rect(digit) abort
  let l:radix = s:radix(a:digit)
  let l:prefix = l:radix ==# 'd' ? s:maybe_prefix(l:radix) : s:prefix(l:radix)
  let l:ureal = s:ureal(a:digit, l:radix)
  let l:real = s:with_infnan('[+-]\?' . l:ureal) . '\?'
  let l:imag = s:with_infnan('[+-]' . l:ureal) . '\?'
  return s:bless(l:prefix . l:real . l:imag . 'i')
endfun

" Build regexp of complex number (polar notation)
fun! r7rs#num#polar(digit) abort
  let l:radix = s:radix(a:digit)
  let l:prefix = l:radix ==# 'd' ? s:maybe_prefix(l:radix) : s:prefix(l:radix)
  let l:ureal = s:ureal(a:digit, l:radix)
  let l:real = s:with_infnan('[+-]\?' . l:ureal)
  let l:imag = l:real
  return s:bless(l:prefix . l:real . '@' . l:imag)
endfun

" Radix letter for the digit
" Example:
"   s:radix('[0-9]') ==> 'd'
"   s:radix('[_0-9]') ==> 'd'
"   s:radix('\x') ==> 'x'
"   s:radix('\w') ==> '\d\{1,2}'
fun! s:radix(digit) abort
  if match(a:digit, '\[01\]') != -1
    return 'b'
  elseif match(a:digit, '\\o') != -1 || match(a:digit, '\[0-7\]') != -1
    return 'o'
  elseif match(a:digit, '\\d') != -1 || match(a:digit, '\[0-9\]') != -1
    return 'd'
  elseif match(a:digit, '\\x') != -1 || match(a:digit, '\[0-9a-fA-F\]') != -1
    return 'x'
  else
    echoe 'no such radix'
  endif
endfun

" Regexp of number prefix, must be
" Example:
"   s:prefix('b') ==> '\%(#b\|#[ei]#b\|#b#[ei]\)'
fun! s:prefix(radix) abort
  if a:radix ==# 'd'
    return '\%(#[eid]\|#[ei]#d\|#d#[ei]\)'
  else
    return '\%(#' . a:radix . '\|#[ei]#' . a:radix . '\|#' . a:radix . '#[ei]\)'
  endif
endfun

" Regexp of number prefix, maybe
" Example:
"   s:maybe_prefix('b') ==> '\%(#b\|#[ei]#b\|#b#[ei]\)\?'
fun! s:maybe_prefix(radix) abort
  return s:prefix(a:radix) . '\?'
endfun

" Regexp of number prefix, no need
" Example:
"   s:no_prefix('b') ==> '\%(#b\|#[ei]#b\|#b#[ei]\)\@<!'
fun! s:no_prefix(radix) abort
  return s:prefix(a:radix) . '\@<!'
endfun

" Regexp of unsigned real number
fun! s:ureal(digit, ...) abort
  let l:radix = get(a:000, 0, s:radix(a:digit))
  let l:ureal = s:int_or_rat(a:digit)
  if l:radix ==# 'd'
    let l:ureal = s:with_frac10(l:ureal)
  endif
  return l:ureal
endfun

" Regexp of integral or rational number
" Example:
"   s:int_or_rat('[0-9]') ==> '[0-9]\+\%(\/[0-9]\+\)\?'
fun! s:int_or_rat(digit) abort
  let l:digits = a:digit . '\+'
  return l:digits . '\%(\/' . l:digits . '\)\?'
endfun

" Wrap any number regexp with regexp of decimal fractional number
" Example:
"   s:with_frac10('NUMBER') ==> '\%(NUMBER\|\%(\d\+\|\.\d\+\|\d\+\.\d*\)\%([esfdl][+-]\d\+\)\?\)'
fun! s:with_frac10(wrapped) abort
  return '\%(' . a:wrapped . '\|\%(\d\+\|\.\d\+\|\d\+\.\d*\)\%([esfdl][+-]\d\+\)\?\)'
endfun

" Wrap any signed number regexp with regexp of inf/nan
" Example:
"   s:with_infnan('[+-]\?NUMBER') ==> '\%([+-]\?NUMBER\|[+-]\%(inf\|nan\)\.0\)'
"   s:with_infnan('[+-]NUMBER')   ==> '[+-]\%(NUMBER\|\%(inf\|nan\)\.0\)'
" a:signed is assumed to start with either '[+-]\?' or '[+-]'
fun! s:with_infnan(signed) abort
  if match(a:signed, '^\[+-\]\\?') != -1
    return '\%(' . a:signed . '\|[+-]\%(inf\|nan\)\.0\)'
  else
    return '[+-]\%(' . substitute(a:signed, '^\[+-\]', '', '') . '\|\%(inf\|nan\)\.0\)'
  endif
endfun

" Finalize building regexp of number
fun! s:bless(blessed) abort
  return '\c\<' . a:blessed . '\>'
endfun

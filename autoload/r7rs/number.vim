" Helper functions for r7rs-syntax plugin
" Last Change: 2020-06-11
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

" Build regexp of real number
fun! r7rs#number#real(digit, ...) abort
  " Optional arguments:
  let l:optionals = get(a:000, 0, {})
  " Determines requirement for prefix; see s:prefix() below.
  let l:prefix_req = get(l:optionals, 'prefix_req')

  let l:radix = s:radix(a:digit)
  let l:prefix = s:prefix(l:radix, l:prefix_req)
  let l:ureal = s:ureal(a:digit, l:radix)
  let l:real = s:with_infnan('[+-]\?' . l:ureal)
  return s:bless(l:prefix . l:real)
endfun

" Build regexp of complex number (rectangular notation)
fun! r7rs#number#rect(digit, ...) abort
  let l:optionals = get(a:000, 0, {})
  let l:prefix_req = get(l:optionals, 'prefix_req')

  let l:radix = s:radix(a:digit)
  let l:prefix = s:prefix(l:radix, l:prefix_req)
  let l:ureal = s:ureal(a:digit, l:radix)
  let l:real = s:with_infnan('[+-]\?' . l:ureal) . '\?'
  let l:imag = s:with_infnan('[+-]' . l:ureal) . '\?'
  return s:bless(l:prefix . l:real . l:imag . 'i')
endfun

" Build regexp of complex number (polar notation)
fun! r7rs#number#polar(digit, ...) abort
  let l:optionals = get(a:000, 0, {})
  let l:prefix_req = get(l:optionals, 'prefix_req')
  " Enables pi-suffix extention in Gauche
  let l:suffix_pi = get(l:optionals, 'suffix_pi')

  let l:radix = s:radix(a:digit)
  let l:prefix = s:prefix(l:radix, l:prefix_req)
  let l:ureal = s:ureal(a:digit, l:radix)
  let l:real = s:with_infnan('[+-]\?' . l:ureal)
  let l:imag = l:real
  let l:pi = l:suffix_pi ? '\%(pi\)\?' : ''
  return s:bless(l:prefix . l:real . '@' . l:imag . l:pi)
endfun

" Radix letter for the digit
" Example:
"   s:radix('[0-9]') ==> 'd'
"   s:radix('[_0-9]') ==> 'd'
"   s:radix('\x') ==> 'x'
"   s:radix('\w') ==> '\d\{1,2}r'
fun! s:radix(digit) abort
  if match(a:digit, '\[_\?01_\?\]') != -1
    return 'b'
  elseif match(a:digit, '\%(\\o\|\[_\?0-7_\?\]\)') != -1
    return 'o'
  elseif match(a:digit, '\%(\\d\|\[_\?0-9_\?\]\)') != -1
    return 'd'
  elseif match(a:digit, '\%(\\x\|\[_\?\%(0-9a-fA-F\|\[:xdigit:\]\)_\?\]\)') != -1
    return 'x'
  elseif match(a:digit, '\%(\\w\|\[_\?\%(0-9a-zA-Z\|\[:alnum:\]\)_\?\]\)') != -1
    return '\d\{1,2}r'
  else
    echoe 'no such radix'
  endif
endfun

" Regexp of number prefix
" Example:
"   s:prefix('b', 0)  ==> '\%(#b\|#[ei]#b\|#b#[ei]\)'
"   s:prefix('d', 0)  ==> '\%(#d\|#[ei]#d\|#d#[ei]\)\?'
"   s:prefix('d', 1)  ==> '\%(#d\|#[ei]#d\|#d#[ei]\)'
"   s:prefix('d', -1) ==> '\%(#d\|#[ei]#d\|#d#[ei]\)\@<!'
" If a:required > 0, it requires prefix to present even for decimal number;
" if a:required == 0, it permits omitting prefix in decimal number;
" and if a:required < 0, it rejects prefix (works only with decimal number).
fun! s:prefix(radix, required) abort
  if a:radix ==# 'd'
    let l:prefix = '\%(#[eid]\|#[ei]#d\|#d#[ei]\)'
  else
    let l:prefix = '\%(#' . a:radix . '\|#[ei]#' . a:radix . '\|#' . a:radix . '#[ei]\)'
  endif
  if a:required > 0
    return l:prefix
  endif
  if a:required < 0
    return l:prefix . '\@<!'
  endif
  if a:radix ==# 'd'
    return l:prefix . '\?'
  endif
  return l:prefix
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

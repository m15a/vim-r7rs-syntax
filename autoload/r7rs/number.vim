" Helper functions for r7rs-syntax plugin
" Last Change: 2021-06-20
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if exists('g:autoloaded_r7rs_number')
  finish
endif
let g:autoloaded_r7rs_number = 1

" Build regexp of real number.
fun! r7rs#number#Real(digit, ...) abort
  " Optional arguments:
  let l:optionals = get(a:000, 0, {})
  " Determines requirement for prefix; see s:Prefix() below.
  let l:prefix_req = get(l:optionals, 'prefix_req')

  let l:radix = s:Radix(a:digit)
  let l:prefix = s:Prefix(l:radix, l:prefix_req)
  let l:ureal = s:UReal(a:digit, l:radix)
  let l:real = s:WithInfNaN('[+-]\?' . l:ureal)
  return s:Bless(l:prefix . l:real)
endfun

" Build regexp of complex number (rectangular notation).
fun! r7rs#number#Rect(digit, ...) abort
  let l:optionals = get(a:000, 0, {})
  let l:prefix_req = get(l:optionals, 'prefix_req')

  let l:radix = s:Radix(a:digit)
  let l:prefix = s:Prefix(l:radix, l:prefix_req)
  let l:ureal = s:UReal(a:digit, l:radix)
  let l:real = s:WithInfNaN('[+-]\?' . l:ureal) . '\?'
  let l:imag = s:WithInfNaN('[+-]' . l:ureal) . '\?'
  return s:Bless(l:prefix . l:real . l:imag . 'i')
endfun

" Build regexp of complex number (polar notation).
fun! r7rs#number#Polar(digit, ...) abort
  let l:optionals = get(a:000, 0, {})
  let l:prefix_req = get(l:optionals, 'prefix_req')
  " Enables pi-suffix extention in Gauche
  let l:suffix_pi = get(l:optionals, 'suffix_pi')

  let l:radix = s:Radix(a:digit)
  let l:prefix = s:Prefix(l:radix, l:prefix_req)
  let l:ureal = s:UReal(a:digit, l:radix)
  let l:real = s:WithInfNaN('[+-]\?' . l:ureal)
  let l:imag = l:real
  let l:pi = l:suffix_pi ? '\%(pi\)\?' : ''
  return s:Bless(l:prefix . l:real . '@' . l:imag . l:pi)
endfun

" Radix letter for the digit.
" Example:
"   s:Radix('[0-9]') ==> 'd'
"   s:Radix('[_0-9]') ==> 'd'
"   s:Radix('\x') ==> 'x'
"   s:Radix('\w') ==> '\d\{1,2}r'
fun! s:Radix(digit) abort
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

" Regexp of number prefix.
" Example:
"   s:Prefix('b', 0)  ==> '\%(#b\|#[ei]#b\|#b#[ei]\)'
"   s:Prefix('d', 0)  ==> '\%(#d\|#[ei]#d\|#d#[ei]\)\?'
"   s:Prefix('d', 1)  ==> '\%(#d\|#[ei]#d\|#d#[ei]\)'
"   s:Prefix('d', -1) ==> '\%(#d\|#[ei]#d\|#d#[ei]\)\@<!'
" If a:required > 0, it requires prefix to present even for decimal number;
" if a:required == 0, it permits omitting prefix in decimal number;
" and if a:required < 0, it rejects prefix (works only with decimal number).
fun! s:Prefix(radix, required) abort
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

" Regexp of unsigned real number.
fun! s:UReal(digit, ...) abort
  let l:radix = get(a:000, 0, s:Radix(a:digit))
  let l:ureal = s:IntOrRat(a:digit)
  if l:radix ==# 'd'
    let l:ureal = s:WithFrac10(l:ureal, a:digit)
  endif
  return l:ureal
endfun

" Regexp of integral or rational number.
" Example:
"   s:IntOrRat('[0-9]') ==> '[0-9]\+\%(\/[0-9]\+\)\?'
fun! s:IntOrRat(digit) abort
  let l:digits = a:digit . '\+'
  return l:digits . '\%(\/' . l:digits . '\)\?'
endfun

" Wrap any number regexp with regexp of decimal fractional number.
" Example:
"   s:WithFrac10('NUMBER') ==> '\%(NUMBER\|\%(\d\+\|\.\d\+\|\d\+\.\d*\)\%([esfdl][+-]?\d\+\)\?\)'
fun! s:WithFrac10(wrapped, ...) abort
  let l:d = get(a:000, 0, '\d')
  return '\%(' . a:wrapped . '\|\%(' . l:d . '\+\|\.' . l:d . '\+\|' . l:d . '\+\.' . l:d . '*\)\%([esfdl][+-]\?' . l:d . '\+\)\?\)'
endfun

" Wrap any signed number regexp with regexp of inf/nan.
" Example:
"   s:WithInfNaN('[+-]\?NUMBER') ==> '\%([+-]\?NUMBER\|[+-]\%(inf\|nan\)\.0\)'
"   s:WithInfNaN('[+-]NUMBER')   ==> '[+-]\%(NUMBER\|\%(inf\|nan\)\.0\)'
" a:signed is assumed to start with either '[+-]\?' or '[+-]'
fun! s:WithInfNaN(signed) abort
  if match(a:signed, '^\[+-\]\\?') != -1
    return '\%(' . a:signed . '\|[+-]\%(inf\|nan\)\.0\)'
  else
    return '[+-]\%(' . substitute(a:signed, '^\[+-\]', '', '') . '\|\%(inf\|nan\)\.0\)'
  endif
endfun

" Finalize building regexp of number.
fun! s:Bless(blessed) abort
  return '\c\<' . a:blessed . '\>'
endfun

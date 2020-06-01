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

" Options {{{

" If (b|g):r7rs_strict is true, the following options are set to obey strict R7RS.
if !exists('b:r7rs_strict')
  let b:r7rs_strict = get(g:, 'r7rs_strict', 0)
endif

if b:r7rs_strict
  " Gauche allows [] and even {} to be parentheses, whereas R7RS does not.
  let b:r7rs_braces_as_parens = 0
  let b:r7rs_braces_as_parens = 0
  " Gauche allows identifiers to begin with '.', [+-], or [0-9], whereas R7RS has some restriction.
  let b:r7rs_strict_identifier = 1
endif

if !exists('b:r7rs_brackets_as_parens')
  let b:r7rs_brackets_as_parens = get(g:, 'r7rs_brackets_as_parens', 1)
endif
if !exists('b:r7rs_braces_as_parens')
  let b:r7rs_braces_as_parens = get(g:, 'r7rs_braces_as_parens', 0)
endif
if !exists('b:r7rs_strict_identifier')
  let b:r7rs_strict_identifier = get(g:, 'r7rs_strict_identifier', 0)
endif

" }}}

" Anything visible other than defined below are error.
syn match r7rsErr /[^[:space:]\n]/

" Delimiters {{{1
let s:parens = '()'
if b:r7rs_brackets_as_parens
  let s:parens .= '\[\]'
endif
if b:r7rs_braces_as_parens
  let s:parens .= '{}'
endif
exe 'syn match r7rsDelim /[|' . s:parens . '";]/'
unlet s:parens

" Comments and directives {{{1
syn cluster r7rsComments contains=r7rsComment,r7rsCommentNested,r7rsCommentSharp,r7rsDirective

" Comments
syn region r7rsComment start=/#\@<!;/ end=/$/
syn region r7rsCommentNested start=/#|/ end=/|#/ contains=r7rsCommentNested
" TODO: highlight nested #;
" In `#; #; hello hello r7rs!`, the two `hello`s should be r7rsCommentDatum but not implemented yet.
syn region r7rsCommentSharp start=/#;/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ skipempty contains=@r7rsComments nextgroup=r7rsCommentDatum

" Directives (cf. R7RS, sec. 2.1 (p. 8) last paragraph)
syn match r7rsDirective /#!\%(no-\)\?fold-case/

" Simple data (cf. R7RS, sec. 7.1.2) {{{1
syn cluster r7rsData contains=r7rsId,r7rsBool,r7rsNum,r7rsChar,r7rsStr,r7rsByteVec

" Identifiers (cf. R7RS, sec. 2.1 ,p. 62, and SmallErrata, 7) {{{2

" Those enclosed by |
syn region r7rsId matchgroup=r7rsDelim start=/|/ skip=/\\[\\|]/ end=/|/ contains=@r7rsEscChars
syn region r7rsCommentDatum start=/|/ skip=/\\[\\|]/ end=/|/ contained

if b:r7rs_strict_identifier

" Those starting with other than ., <explicit sign>, and <digit>
"   Here, <subsequent> are replaced with [^[:space:]\n|()";'`,\\#\[\]{}].
"   <subsequent> \ <initial> = <digit> | <special subsequent> =  [.+\-0-9]
syn match r7rsId /[^.+\-0-9[:space:]\n|()";'`,\\#\[\]{}][^[:space:]\n|()";'`,\\#\[\]{}]*/
syn match r7rsCommentDatum /[^.+\-0-9[:space:]\n|()";'`,\\#\[\]{}][^[:space:]\n|()";'`,\\#\[\]{}]*/ contained

" Peculiar identifier case 1 and 2
"   <sign subsequent> = <initial> | <explicit sign> = [^.0-9[:space:]\n|()";'`,\\#\[\]{}]
syn match r7rsId /[+-]\%([^.0-9[:space:]\n|()";'`,\\#\[\]{}][^[:space:]\n|()";'`,\\#\[\]{}]*\)\?/
syn match r7rsCommentDatum /[+-]\%([^.0-9[:space:]\n|()";'`,\\#\[\]{}][^[:space:]\n|()";'`,\\#\[\]{}]*\)\?/ contained

" Peculiar identifier case 3 and 4
syn match r7rsId /[+-]\?\.[^0-9[:space:]\n|()";'`,\\#\[\]{}][^[:space:]\n|()";'`,\\#\[\]{}]*/
syn match r7rsCommentDatum /[+-]\?\.[^0-9[:space:]\n|()";'`,\\#\[\]{}][^[:space:]\n|()";'`,\\#\[\]{}]*/ contained

else

" Anything except single '.' is permitted.
syn match r7rsId /\.[^[:space:]\n|()";'`,\\#\[\]{}]\+/
syn match r7rsId /[^.[:space:]\n|()";'`,\\#\[\]{}][^[:space:]\n|()";'`,\\#\[\]{}]*/
syn match r7rsCommentDatum /\.[^[:space:]\n|()";'`,\\#\[\]{}]\+/ contained
syn match r7rsCommentDatum /[^.[:space:]\n|()";'`,\\#\[\]{}][^[:space:]\n|()";'`,\\#\[\]{}]*/ contained

endif

" Number (cf. R7RS, pp. 62-63) {{{2

" Note that alphabets are case-insensitive in numeric literals.

" Non-decimal number
" ( #b | #[ei]#b | #b#[ei] )  " prefix #b and #[ei] can be swapped
" ( " Real number
"   ( [+-]?[01]+(\/[01]+)?  " integer or rational
"   | [+-](inf|nan)\.0      " inf or nan
"   )
"   " Complex number in rectangular notation
" | ( [+-]?[01]+(\/[01]+)? | [+-](inf|nan)\.0 )?
"   [+-]
"   ( [01]+(\/[01]+)? | (inf|nan)\.0 )?
"   i
"   " Complex number in polar notation
" | ( [+-]?[01]+(\/[01]+)? | [+-](inf|nan)\.0 )
"   \@
"   ( [+-]?[01]+(\/[01]+)? | [+-](inf|nan)\.0 )
" )
" >  " word boundary
" Other radixes are analogous to the above binary case.
syn match r7rsNum /\v\c%(#b|#[ei]#b|#b#[ei])%(%([+-]?[01]+%(\/[01]+)?|[+-]%(inf|nan)\.0)|%([+-]?[01]+%(\/[01]+)?|[+-]%(inf|nan)\.0)?[+-]%([01]+%(\/[01]+)?|%(inf|nan)\.0)?i|%([+-]?[01]+%(\/[01]+)?|[+-]%(inf|nan)\.0)\@%([+-]?[01]+%(\/[01]+)?|[+-]%(inf|nan)\.0))>/
syn match r7rsCommentDatum /\v\c%(#b|#[ei]#b|#b#[ei])%(%([+-]?[01]+%(\/[01]+)?|[+-]%(inf|nan)\.0)|%([+-]?[01]+%(\/[01]+)?|[+-]%(inf|nan)\.0)?[+-]%([01]+%(\/[01]+)?|%(inf|nan)\.0)?i|%([+-]?[01]+%(\/[01]+)?|[+-]%(inf|nan)\.0)\@%([+-]?[01]+%(\/[01]+)?|[+-]%(inf|nan)\.0))>/ contained
syn match r7rsNum /\v\c%(#o|#[ei]#o|#o#[ei])%(%([+-]?\o+%(\/\o+)?|[+-]%(inf|nan)\.0)|%([+-]?\o+%(\/\o+)?|[+-]%(inf|nan)\.0)?[+-]%(\o+%(\/\o+)?|%(inf|nan)\.0)?i|%([+-]?\o+%(\/\o+)?|[+-]%(inf|nan)\.0)\@%([+-]?\o+%(\/\o+)?|[+-]%(inf|nan)\.0))>/
syn match r7rsCommentDatum /\v\c%(#o|#[ei]#o|#o#[ei])%(%([+-]?\o+%(\/\o+)?|[+-]%(inf|nan)\.0)|%([+-]?\o+%(\/\o+)?|[+-]%(inf|nan)\.0)?[+-]%(\o+%(\/\o+)?|%(inf|nan)\.0)?i|%([+-]?\o+%(\/\o+)?|[+-]%(inf|nan)\.0)\@%([+-]?\o+%(\/\o+)?|[+-]%(inf|nan)\.0))>/ contained
syn match r7rsNum /\v\c%(#x|#[ei]#x|#x#[ei])%(%([+-]?\x+%(\/\x+)?|[+-]%(inf|nan)\.0)|%([+-]?\x+%(\/\x+)?|[+-]%(inf|nan)\.0)?[+-]%(\x+%(\/\x+)?|%(inf|nan)\.0)?i|%([+-]?\x+%(\/\x+)?|[+-]%(inf|nan)\.0)\@%([+-]?\x+%(\/\x+)?|[+-]%(inf|nan)\.0))>/
syn match r7rsCommentDatum /\v\c%(#x|#[ei]#x|#x#[ei])%(%([+-]?\x+%(\/\x+)?|[+-]%(inf|nan)\.0)|%([+-]?\x+%(\/\x+)?|[+-]%(inf|nan)\.0)?[+-]%(\x+%(\/\x+)?|%(inf|nan)\.0)?i|%([+-]?\x+%(\/\x+)?|[+-]%(inf|nan)\.0)\@%([+-]?\x+%(\/\x+)?|[+-]%(inf|nan)\.0))>/ contained

" Decimal number
" ( #[dei] | #[ei]#d | #d#[ei] )?  " no prefix or prefixed by #d, #[ei], #d#[ei], or #[ei]#d
" ( " Real number
"   ( [+-]? ( \d+(\/\d+)?   " integer or rational
"           | ( \d+\.\d*    " fractional case 1
"             | 0*\.\d+      " fractional case 2
"             )
"             ([esfdl][+-]\d+)?  " fractional number may have this suffix
"           )
"   | [+-](inf|nan)\.0
"   )
"   " Complex number in rectangular notation
" | ( [+-]? ( \d+(\/\d+)?
"           | ( \d+\.\d* | 0*\.\d+ ) ([esfdl][+-]\d+)?
"           )
"   | [+-](inf|nan)\.0
"   )?
"   [+-]
"   ( \d+(\/\d+)?
"   | ( \d+\.\d* | 0*\.\d+ ) ([esfdl][+-]\d+)?
"   | (inf|nan)\.0
"   )?
"   i
"   " Complex number in polar notation
" | ( [+-]? ( \d+(\/\d+)?
"           | ( \d+\.\d* | 0*\.\d+ ) ([esfdl][+-]\d+)?
"           )
"   | [+-](inf|nan)\.0
"   )
"   \@
"   ( [+-]? ( \d+(\/\d+)?
"           | ( \d+\.\d* | 0*\.\d+ ) ([esfdl][+-]\d+)?
"           )
"   | [+-](inf|nan)\.0
"   )
" )
" >  " word boundary
syn match r7rsNum /\v\c%(#[dei]|#[ei]#d|#d#[ei])?%(%([+-]?%(\d+%(\/\d+)?|%(\d+\.\d*|0*\.\d+)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)|%([+-]?%(\d+%(\/\d+)?|%(\d+\.\d*|0*\.\d+)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)?[+-]%(\d+%(\/\d+)?|%(\d+\.\d*|0*\.\d+)%([esfdl][+-]\d+)?|%(inf|nan)\.0)?i|%([+-]?%(\d+%(\/\d+)?|%(\d+\.\d*|0*\.\d+)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)\@%([+-]?%(\d+%(\/\d+)?|%(\d+\.\d*|0*\.\d+)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0))>/
syn match r7rsCommentDatum /\v\c%(#[dei]|#[ei]#d|#d#[ei])?%(%([+-]?%(\d+%(\/\d+)?|%(\d+\.\d*|0*\.\d+)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)|%([+-]?%(\d+%(\/\d+)?|%(\d+\.\d*|0*\.\d+)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)?[+-]%(\d+%(\/\d+)?|%(\d+\.\d*|0*\.\d+)%([esfdl][+-]\d+)?|%(inf|nan)\.0)?i|%([+-]?%(\d+%(\/\d+)?|%(\d+\.\d*|0*\.\d+)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)\@%([+-]?%(\d+%(\/\d+)?|%(\d+\.\d*|0*\.\d+)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0))>/ contained

" Boolean {{{2
syn match r7rsBool /#t\%(rue\)\?/
syn match r7rsBool /#f\%(alse\)\?/
syn match r7rsCommentDatum /#t\%(rue\)\?/ contained
syn match r7rsCommentDatum /#f\%(alse\)\?/ contained

" Character {{{2
syn match r7rsChar /#\\./
syn match r7rsChar /#\\x\x\+/
syn match r7rsChar /#\\\%(alarm\|backspace\|delete\|escape\|newline\|null\|return\|space\|tab\)/
syn match r7rsCommentDatum /#\\./ contained
syn match r7rsCommentDatum /#\\x\x\+/ contained
syn match r7rsCommentDatum /#\\\%(alarm\|backspace\|delete\|escape\|newline\|null\|return\|space\|tab\)/ contained

" String {{{2
syn region r7rsStr matchgroup=r7rsDelim start=/"/ skip=/\\[\\"]/ end=/"/ contains=@r7rsEscChars,r7rsEscWrap
syn region r7rsCommentDatum start=/"/ skip=/\\[\\"]/ end=/"/ contained

" Escaped characters (embedded in \"strings\" and |symbols|) {{{2
syn cluster r7rsEscChars contains=r7rsEscDelim,r7rsEscHex,r7rsEscMnemonic
syn match r7rsEscDelim /\\[\\|"]/ contained
syn match r7rsEscHex /\\x\x\+;/ contained
syn match r7rsEscMnemonic /\\[abtnr]/ contained

" This can be contained in strings but symbols
syn match r7rsEscWrap /\\[[:space:]]*$/ contained

" Bytevectors {{{2
syn region r7rsByteVec matchgroup=r7rsDelim start=/#u8(/ end=/)/ contains=r7rsErr,r7rsNum

" Compound data {{{1

" Note that , and ,@ are omitted since they can appear only in quasiquotes.
" syn cluster r7rsData add=r7rsList,r7rsVec,r7rsQ,r7rsQQ,
" Labels
" syn cluster r7rsData add=r7rsLabel

" syn cluster r7rsData add=r7rsSyn,r7rsProc
" Auxiliary syntax
" syn cluster r7rsSynAux contains=r7rsUnq,r7rsDot,r7rsElse

  " syn region r7rsParens start=/(/ end=/)/ contains=@r7rsTokens,@r7rsComments
  " syn region r7rsParens start=/\[/ end=/\]/ contains=r7rsParens,@r7rsComments

" TODO: Add more datum pattern
" syn region r7rsCommentDatum start=/(/ end=/)/ contained
" if b:r7rs_use_square_brackets
"   syn region r7rsCommentDatum start=/\[/ end=/\]/ contained
" endif

" syn region r7rsQuote start=/'['`]*/ end=/\ze[[:space:]\n|()";]/ contains=r7rsIdentifier

" Highlights {{{1

hi def link r7rsErr Error
hi def link r7rsDelim Delimiter
hi def link r7rsComment Comment
hi def link r7rsCommentNested Comment
hi def link r7rsCommentSharp Comment
hi def link r7rsCommentDatum r7rsCommentSharp
hi def link r7rsDirective Comment
hi def link r7rsId Normal
hi def link r7rsNum Number
hi def link r7rsBool Boolean
hi def link r7rsChar Character
hi def link r7rsStr String
hi def link r7rsEscDelim Character
hi def link r7rsEscHex Character
hi def link r7rsEscMnemonic SpecialChar
hi def link r7rsEscWrap SpecialChar

" Keywords {{{1


let b:current_syntax = 'r7rs'

let &cpo = s:cpo
unlet s:cpo

" vim: tw=120 fdm=marker

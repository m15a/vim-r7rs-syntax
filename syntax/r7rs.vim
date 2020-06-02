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

" Options {{{1

" If (b|g):r7rs_strict is true, the following options are set to obey strict R7RS.
if !exists('b:r7rs_strict')
  let b:r7rs_strict = get(g:, 'r7rs_strict', 0)
endif

if b:r7rs_strict
  " Gauche allows [] and even {} to be parentheses, whereas R7RS does not.
  let b:r7rs_brackets_as_parens = 0
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

" Anything visible other than defined below are error. {{{1
syn match r7rsErr /[^[:space:]\n]/

" Comments and directives {{{1
syn cluster r7rsComments contains=r7rsComment,r7rsCommentNested,r7rsCommentSharp,r7rsDirective

" Comments
syn region r7rsComment start=/#\@<!;/ end=/$/
syn region r7rsCommentNested start=/#|/ end=/|#/ contains=r7rsCommentNested
" TODO: highlight nested #;
" In `#; #; hello hello r7rs!`, the two `hello`s should be r7rsCommentDatum but not implemented yet.
syn region r7rsCommentSharp start=/#;/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contains=@r7rsComments skipwhite skipempty nextgroup=r7rsCommentDatum

" Directives (cf. R7RS, sec. 2.1 (p. 8) last paragraph)
syn match r7rsDirective /#!\%(no-\)\?fold-case/

" Simple data (cf. R7RS, sec. 7.1.2) {{{1
syn cluster r7rsData contains=@r7rsDataSimple,@r7rsDataCompound,r7rsLabel
syn cluster r7rsDataSimple contains=r7rsId,r7rsBool,r7rsNum,r7rsChar,r7rsStr,r7rsByteVec

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
syn region r7rsByteVec matchgroup=r7rsDelim start=/#u8(/ end=/)/ contains=r7rsErr,@r7rsComments,r7rsNum

" Compound data (cf. R7RS, sec. 7.1.2) {{{1
syn cluster r7rsDataCompound contains=r7rsList,r7rsVec,r7rsQ,r7rsQQ

" Normal lists and vector {{{2
syn region r7rsList matchgroup=r7rsDelim start=/#\@<!(/ end=/)/ contains=r7rsErr,@r7rsComments,@r7rsData
if b:r7rs_brackets_as_parens
  syn region r7rsList matchgroup=r7rsDelim start=/#\@<!\[/ end=/\]/ contains=r7rsErr,@r7rsComments,@r7rsData
endif
if b:r7rs_braces_as_parens
  syn region r7rsList matchgroup=r7rsDelim start=/#\@<!{/ end=/}/ contains=r7rsErr,@r7rsComments,@r7rsData
endif
syn region r7rsVec matchgroup=r7rsDelim start=/#(/ end=/)/ contains=r7rsErr,@r7rsComments,@r7rsData

" Quoted simple data (any identifier, |symbol|, \"string\", or #-syntax other than '#(') {{{2
syn match r7rsQ /'\ze[^[:space:]\n();'`,\\#\[\]{}]/ nextgroup=r7rsDataSimple
syn match r7rsQ /'\ze#[^(]/ nextgroup=r7rsDataSimple

" Quoted lists and vector {{{2
syn match r7rsQ /'\ze(/ nextgroup=r7rsQList
syn region r7rsQList matchgroup=r7rsDelim start=/(/ end=/)/ contained contains=r7rsErr,@r7rsComments,@r7rsData
if b:r7rs_brackets_as_parens
  syn match r7rsQ /'\ze\[/ nextgroup=r7rsQList
  syn region r7rsQList matchgroup=r7rsDelim start=/\[/ end=/\]/ contains=r7rsErr,@r7rsComments,@r7rsData
endif
if b:r7rs_braces_as_parens
  syn match r7rsQ /'\ze{/ nextgroup=r7rsQList
  syn region r7rsQList matchgroup=r7rsDelim start=/{/ end=/}/ contains=r7rsErr,@r7rsComments,@r7rsData
endif
syn match r7rsQ /'\ze#(/ nextgroup=r7rsQVec
syn region r7rsQVec matchgroup=r7rsDelim start=/#(/ end=/)/ contained contains=r7rsErr,@r7rsComments,@r7rsData

" Quoted quotes {{{2
syn match r7rsQ /'\ze'/ nextgroup=r7rsQ
syn match r7rsQ /'\ze`/ nextgroup=r7rsQQ

" Quasiquoted simple data (any identifier, |symbol|, \"string\", or #-syntax other than '#(') {{{2
syn match r7rsQQ /`\ze[^[:space:]\n();'`,\\#\[\]{}]/ nextgroup=r7rsDataSimple
syn match r7rsQQ /`\ze#[^(]/ nextgroup=r7rsDataSimple

" Quasiquoted lists and vector {{{2
syn match r7rsQQ /`\ze(/ nextgroup=r7rsQQList
syn region r7rsQQList matchgroup=r7rsDelim start=/(/ end=/)/ contained contains=r7rsErr,@r7rsComments,@r7rsData,r7rsU
if b:r7rs_brackets_as_parens
  syn match r7rsQQ /`\ze\[/ nextgroup=r7rsQQList
  syn region r7rsQQList matchgroup=r7rsDelim start=/\[/ end=/\]/ contains=r7rsErr,@r7rsComments,@r7rsData,r7rsU
endif
if b:r7rs_braces_as_parens
  syn match r7rsQQ /`\ze{/ nextgroup=r7rsQQList
  syn region r7rsQQList matchgroup=r7rsDelim start=/{/ end=/}/ contains=r7rsErr,@r7rsComments,@r7rsData,r7rsU
endif
syn match r7rsQQ /`\ze#(/ nextgroup=r7rsQQVec
syn region r7rsQQVec matchgroup=r7rsDelim start=/#(/ end=/)/ contained contains=r7rsErr,@r7rsComments,@r7rsData,r7rsU

" Quasiquoted quotes {{{2
syn match r7rsQQ /`\ze'/ nextgroup=r7rsQ
syn match r7rsQQ /`\ze`/ nextgroup=r7rsQQ

" Unquote {{{2
" It allows comments before reaching any datum.
syn region r7rsU start=/,@\?/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contained contains=@r7rsComments skipwhite skipempty nextgroup=@r7rsData

" Dot '.' {{{2
syn keyword r7rsDot . contained containedin=r7rsList,r7rsQList,r7rsQQList

" Labels (cf. R7RS, sec. 2.4) {{{1
syn match r7rsLabel /#\d\+#/
syn region r7rsLabel start=/#\d\+=/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contains=@r7rsComments skipwhite skipempty nextgroup=@r7rsData

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
hi def link r7rsQ r7rsSyn
hi def link r7rsQQ r7rsSyn
hi def link r7rsU Special
hi def link r7rsDot Special
hi def link r7rsSyn Statement
hi def link r7rsLabel Underlined

" Keywords {{{1


let b:current_syntax = 'r7rs'

let &cpo = s:cpo
unlet s:cpo

" vim: tw=150 fdm=marker

" Vim syntax file
" Language: Scheme (Gauche)
" Last Change: 2020-06-05
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: MIT

if !exists('b:did_r7rs_syntax')
  finish
endif

" Comments and directives {{{1
syn cluster r7rsComs add=gaucheShebang,gaucheDirective,gaucheDebug

" Comments {{{2

" Comment out character set (':]' is contained in POSIX character set)
syn region r7rsComDatum start=/#\[/ skip=/\\[\\\]]/ end=/\]/ contained contains=gaucheComDatumPOSIX
syn region gaucheComDatumPOSIX start=/\\\@<!\[:/ end=/:\]/ contained
" Comment out incomplete/interpolated string
syn region r7rsComDatum start=/#\*\?"/ skip=/\\[\\"]/ end=/"/ contained

" Directives {{{2
syn match gaucheShebang /\%^#![\/ ].*$/
syn match gaucheDirective /#!\(gauche-legacy\|r[67]rs\)/

" Debug directive {{{2
syn match gaucheDebug /#?[,=]/

" Simple data {{{1
syn cluster r7rsDataSimple remove=r7rsBVec
syn cluster r7rsDataSimple add=gaucheKey,gaucheNum,gaucheChar,gaucheCharSet,gaucheStrI,gaucheStrQQ,gaucheUVec

" Keyword symbols {{{2
syn match gaucheKey /#\?:[^[:space:]\n|()";'`,\\#\[\]{}]*/

" Number {{{2
syn clear r7rsNum

" Gauche extensions:
" 1. Use of '_' in prefixed numeric literals
" 2. 'pi'-suffix in polar notation
" 3. Common lisp style #nr prefix

" Non-decimal number {{{3

" Real number {{{4
" ( #b | #[ei]#b | #b#[ei] )  " prefix #b and #[ei] can be swapped
" ( [+-]?[_01]+(\/[_01]+)?    " integer or rational
" | [+-](inf|nan)\.0          " inf or nan
" )
" Other radixes are analogous to the above binary case.
syn match gaucheNum /\v\c%(#b|#[ei]#b|#b#[ei])%([+-]?[_01]+%(\/[_01]+)?|[+-]%(inf|nan)\.0)>/
syn match gaucheNum /\v\c%(#o|#[ei]#o|#o#[ei])%([+-]?[_0-7]+%(\/[_0-7]+)?|[+-]%(inf|nan)\.0)>/
syn match gaucheNum /\v\c%(#x|#[ei]#x|#x#[ei])%([+-]?[_[:xdigit:]]+%(\/[_[:xdigit:]]+)?|[+-]%(inf|nan)\.0)>/

" Complex number in rectangular notation {{{4
" ( #b | #[ei]#b | #b#[ei] )
" ( [+-]?[_01]+(\/[_01]+)? | [+-](inf|nan)\.0 )?
" [+-]
" ( [_01]+(\/[_01]+)? | (inf|nan)\.0 )?
" i
syn match gaucheNum /\v\c%(#b|#[ei]#b|#b#[ei])%([+-]?[_01]+%(\/[_01]+)?|[+-]%(inf|nan)\.0)?[+-]%([_01]+%(\/[_01]+)?|%(inf|nan)\.0)?i>/
syn match gaucheNum /\v\c%(#o|#[ei]#o|#o#[ei])%([+-]?[_0-7]+%(\/[_0-7]+)?|[+-]%(inf|nan)\.0)?[+-]%([_0-7]+%(\/[_0-7]+)?|%(inf|nan)\.0)?i>/
syn match gaucheNum /\v\c%(#x|#[ei]#x|#x#[ei])%([+-]?[_[:xdigit:]]+%(\/[_[:xdigit:]]+)?|[+-]%(inf|nan)\.0)?[+-]%([_[:xdigit:]]+%(\/[_[:xdigit:]]+)?|%(inf|nan)\.0)?i>/

" Complex number in polar notation {{{4
" ( #b | #[ei]#b | #b#[ei] )
" ( [+-]?[_01]+(\/[_01]+)? | [+-](inf|nan)\.0 )
" \@
" ( [+-]?[_01]+(\/[_01]+)? | [+-](inf|nan)\.0 )
" (pi)?
syn match gaucheNum /\v\c%(#b|#[ei]#b|#b#[ei])%([+-]?[_01]+%(\/[_01]+)?|[+-]%(inf|nan)\.0)\@%([+-]?[_01]+%(\/[_01]+)?|[+-]%(inf|nan)\.0)(pi)?>/
syn match gaucheNum /\v\c%(#o|#[ei]#o|#o#[ei])%([+-]?[_0-7]+%(\/[_0-7]+)?|[+-]%(inf|nan)\.0)\@%([+-]?[_0-7]+%(\/[_0-7]+)?|[+-]%(inf|nan)\.0)(pi)?>/
syn match gaucheNum /\v\c%(#x|#[ei]#x|#x#[ei])%([+-]?[_[:xdigit:]]+%(\/[_[:xdigit:]]+)?|[+-]%(inf|nan)\.0)\@%([+-]?[_[:xdigit:]]+%(\/[_[:xdigit:]]+)?|[+-]%(inf|nan)\.0)(pi)?>/

" Common-Lisp-y radix prefixed notation {{{3

" NOTE: Radix can be from 2 to 36 so #\d{1,2} is sufficient, though inaccurate.

" Real number {{{4
" ( #\d{1,2}r | #[ei]#\d{1,2}r | #\d{1,2}r#[ei] )
" ( [+-]?\w+(\/\w+)?
" | [+-](inf|nan)\.0
" )
" Other radixes are analogous to the above binary case.
syn match gaucheNum /\v\c%(#\d{1,2}r|#[ei]#\d{1,2}r|#\d{1,2}r#[ei])%([+-]?\w+%(\/\w+)?|[+-]%(inf|nan)\.0)>/

" Complex number in rectangular notation {{{4
" ( #\d{1,2}r | #[ei]#\d{1,2}r | #\d{1,2}r#[ei] )
" ( [+-]?\w+(\/\w+)? | [+-](inf|nan)\.0 )?
" [+-]
" ( \w+(\/\w+)? | (inf|nan)\.0 )?
" i
syn match gaucheNum /\v\c%(#\d{1,2}r|#[ei]#\d{1,2}r|#\d{1,2}r#[ei])%([+-]?\w+%(\/\w+)?|[+-]%(inf|nan)\.0)?[+-]%(\w+%(\/\w+)?|%(inf|nan)\.0)?i>/

" Complex number in polar notation {{{4
" ( #\d{1,2}r | #[ei]#\d{1,2}r | #\d{1,2}r#[ei] )
" ( [+-]?\w+(\/\w+)? | [+-](inf|nan)\.0 )
" \@
" ( [+-]?\w+(\/\w+)? | [+-](inf|nan)\.0 )
" (pi)?
syn match gaucheNum /\v\c%(#\d{1,2}r|#[ei]#\d{1,2}r|#\d{1,2}r#[ei])%([+-]?\w+%(\/\w+)?|[+-]%(inf|nan)\.0)\@%([+-]?\w+%(\/\w+)?|[+-]%(inf|nan)\.0)(pi)?>/

" Decimal number (prefixed) {{{3

" Real number {{{4
" ( #[dei] | #[ei]#d | #d#[ei] )   " prefixed by #d, #[ei], #d#[ei], or #[ei]#d
" ( [+-]? ( [_0-9]+(\/[_0-9]+)?    " integer or rational
"         | ( [_0-9]+              " fractional case 1
"           | \.[_0-9]+            " fractional case 2
"           | [_0-9]+\.[_0-9]*     " fractional case 3
"           )
"           ([esfdl][+-][_0-9]+)?  " fractional number may have this suffix
"         )
" | [+-](inf|nan)\.0
" )
syn match gaucheNum /\v\c%(#[dei]|#[ei]#d|#d#[ei])%([+-]?%([_0-9]+%(\/[_0-9]+)?|%([_0-9]+|\.[_0-9]+|[_0-9]+\.[_0-9]*)%([esfdl][+-][_0-9]+)?)|[+-]%(inf|nan)\.0)>/

" Complex number in rectangular notation {{{4
" ( #[dei] | #[ei]#d | #d#[ei] )
" ( [+-]? ( [_0-9]+(\/[_0-9]+)?
"         | ( [_0-9]+ | \.[_0-9]+ | [_0-9]+\.[_0-9]* ) ([esfdl][+-][_0-9]+)?
"         )
" | [+-](inf|nan)\.0
" )?
" [+-]
" ( ( [_0-9]+(\/[_0-9]+)?
"   | ( [_0-9]+ | \.[_0-9]+ | [_0-9]+\.[_0-9]* ) ([esfdl][+-][_0-9]+)?
"   )
" | (inf|nan)\.0
" )?
" i
syn match gaucheNum /\v\c%(#[dei]|#[ei]#d|#d#[ei])%([+-]?%([_0-9]+%(\/[_0-9]+)?|%([_0-9]+|\.[_0-9]+|[_0-9]+\.[_0-9]*)%([esfdl][+-][_0-9]+)?)|[+-]%(inf|nan)\.0)?[+-]%(%([_0-9]+%(\/[_0-9]+)?|%([_0-9]+|\.[_0-9]+|[_0-9]+\.[_0-9]*)%([esfdl][+-][_0-9]+)?)|%(inf|nan)\.0)?i>/

" Complex number in polar notation {{{4
" ( #[dei] | #[ei]#d | #d#[ei] )
" ( [+-]? ( [_0-9]+(\/[_0-9]+)?
"         | ( [_0-9]+ | \.[_0-9]+ | [_0-9]+\.[_0-9]* ) ([esfdl][+-][_0-9]+)?
"         )
" | [+-](inf|nan)\.0
" )
" \@
" ( [+-]? ( [_0-9]+(\/[_0-9]+)?
"         | ( [_0-9]+ | \.[_0-9]+ | [_0-9]+\.[_0-9]* ) ([esfdl][+-][_0-9]+)?
"         )
" | [+-](inf|nan)\.0
" )
" (pi)?
syn match gaucheNum /\v\c%(#[dei]|#[ei]#d|#d#[ei])%([+-]?%([_0-9]+%(\/[_0-9]+)?|%([_0-9]+|\.[_0-9]+|[_0-9]+\.[_0-9]*)%([esfdl][+-][_0-9]+)?)|[+-]%(inf|nan)\.0)\@%([+-]?%([_0-9]+%(\/[_0-9]+)?|%([_0-9]+|\.[_0-9]+|[_0-9]+\.[_0-9]*)%([esfdl][+-][_0-9]+)?)|[+-]%(inf|nan)\.0)(pi)?>/

" Decimal number (no prefix) {{{3

" Real number {{{4
" ( #[dei] | #[ei]#d | #d#[ei] )@<!  " no prefix
" ( [+-]? ( \d+(\/\d+)?              " integer or rational
"         | ( \d+                    " fractional case 1
"           | \.\d+                  " fractional case 2
"           | \d+\.\d*               " fractional case 3
"           )
"           ([esfdl][+-]\d+)?        " fractional number may have this suffix
"         )
" | [+-](inf|nan)\.0
" )
syn match gaucheNum /\v\c%(#[dei]|#[ei]#d|#d#[ei])@<!%([+-]?%(\d+%(\/\d+)?|%(\d+|\.\d+|\d+\.\d*)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)>/

" Complex number in rectangular notation {{{4
" ( #[dei] | #[ei]#d | #d#[ei] )@<!
" ( [+-]? ( \d+(\/\d+)?
"         | ( \d+ | \.\d+ | \d+\.\d* ) ([esfdl][+-]\d+)?
"         )
" | [+-](inf|nan)\.0
" )?
" [+-]
" ( ( \d+(\/\d+)?
"   | ( \d+ | \.\d+ | \d+\.\d* ) ([esfdl][+-]\d+)?
"   )
" | (inf|nan)\.0
" )?
" i
syn match gaucheNum /\v\c%(#[dei]|#[ei]#d|#d#[ei])@<!%([+-]?%(\d+%(\/\d+)?|%(\d+|\.\d+|\d+\.\d*)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)?[+-]%(%(\d+%(\/\d+)?|%(\d+|\.\d+|\d+\.\d*)%([esfdl][+-]\d+)?)|%(inf|nan)\.0)?i>/

" Complex number in polar notation {{{4
" ( #[dei] | #[ei]#d | #d#[ei] )@<!
" ( [+-]? ( \d+(\/\d+)?
"         | ( \d+ | \.\d+ | \d+\.\d* ) ([esfdl][+-]\d+)?
"         )
" | [+-](inf|nan)\.0
" )
" \@
" ( [+-]? ( \d+(\/\d+)?
"         | ( \d+ | \.\d+ | \d+\.\d* ) ([esfdl][+-]\d+)?
"         )
" | [+-](inf|nan)\.0
" )
" (pi)?
syn match gaucheNum /\v\c%(#[dei]|#[ei]#d|#d#[ei])@<!%([+-]?%(\d+%(\/\d+)?|%(\d+|\.\d+|\d+\.\d*)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)\@%([+-]?%(\d+%(\/\d+)?|%(\d+|\.\d+|\d+\.\d*)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)(pi)?>/

" Character {{{2

" Although R7RS character names are case sensitive, Gauche character names are
" case insensitive (cf. Gauche ref, sec. 6.10).
syn match gaucheChar /\c#\\\%(alarm\|backspace\|del\%(ete\)\?\|esc\%(ape\)\?\|newline\|null\|return\|space\|tab\)/
syn match gaucheChar /\c#\\\%(nl\|lf\|cr\|ht\|page\)/

" Character set {{{2
syn match gaucheCharSet /#\ze\[/ nextgroup=gaucheCSSpec
syn region gaucheCSSpec matchgroup=r7rsDelim start=/\[/ skip=/\\[\\\]]/ end=/\]/ contained contains=@gaucheCSEscChars

" Escaped characters (embedded in #[character set]) {{{2
syn cluster gaucheCSEscChars contains=gaucheCSEscMeta,r7rsEscHex,gaucheCSEscMnemonic,gaucheCSEscLiteral,gaucheCSEscPOSIX
syn match gaucheCSEscMeta /\v%(\\@<!\[\^?)@<!-\]@!/ contained
syn match gaucheCSEscMeta /\v%(\\@<!\[)@<=\^/ contained
syn match gaucheCSEscMnemonic /\\[sSdDwW]/ contained
syn match gaucheCSEscLiteral /\\[\\\-^\[\]]/ contained
syn match gaucheCSEscPOSIX /\v\[:\^?%(al%(pha|num)|blank|cntrl|x?digit|graph|lower|print|punct|space|upper|word|ascii):\]/ contained
syn match gaucheCSEscPOSIX /\v\[:\^?%(AL%(PHA|NUM)|BLANK|CNTRL|X?DIGIT|GRAPH|LOWER|PRINT|PUNCT|SPACE|UPPER|WORD|ASCII):\]/ contained

" Incomplete string {{{2
syn region gaucheStrI matchgroup=r7rsDelim start=/#\*"/ skip=/\\[\\"]/ end=/"/ contains=@r7rsEscChars,r7rsEscWrap

" Interpolated string {{{2
syn region gaucheStrQQ matchgroup=r7rsDelim start=/#"/ skip=/\\[\\"]/ end=/"/ contains=@r7rsEscChars,r7rsEscWrap,gaucheStrQQU
syn region gaucheStrQQU start=/\~\@<!\~\~\@!/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contained contains=@r7rsComs skipwhite skipempty nextgroup=@r7rsData

" Escaped characters (embedded in \"strings\" and |identifiers|) {{{2
syn cluster r7rsEscChars add=gaucheEscHex,gaucheEscMnemonic
syn match gaucheEscHex /\\u\x\{4}/ contained
syn match gaucheEscHex /\\U\x\{8}/ contained
syn match gaucheEscMnemonic /\\[f0]/ contained

" Uniform vectors {{{2
syn clear r7rsBVec
syn region gaucheUVec matchgroup=r7rsDelim start=/#[us]\%(8\|16\|32\|64\)(/ end=/)/ contains=r7rsErr,@r7rsComs,gaucheNum
syn region gaucheUVec matchgroup=r7rsDelim start=/#f\%(16\|32\|64\)(/ end=/)/ contains=r7rsErr,@r7rsComs,gaucheNum
syn region gaucheUVec matchgroup=r7rsDelim start=/#c\%(32\|64\|128\)(/ end=/)/ contains=r7rsErr,@r7rsComs,gaucheNum

" Highlights {{{1

hi def link gaucheComDatumPOSIX r7rsCom
hi def link gaucheShebang r7rsCom
hi def link gaucheDirective r7rsDirective
hi def link gaucheDebug r7rsCom
hi def link gaucheKey Special
hi def link gaucheNum r7rsNum
hi def link gaucheChar r7rsChar
hi def link gaucheCharSet r7rsDelim
hi def link gaucheCSSpec r7rsStr
hi def link gaucheCSEscMeta r7rsCharM
hi def link gaucheCSEscMnemonic r7rsEscMnemonic
hi def link gaucheCSEscLiteral r7rsEscLiteral
hi def link gaucheCSEscPOSIX r7rsCharM
hi def link gaucheStrI r7rsStr
hi def link gaucheStrQQ r7rsStr
hi def link gaucheStrQQU r7rsU
hi def link gaucheEscHex r7rsEscHex
hi def link gaucheEscMnemonic r7rsEscMnemonic

" }}}

" vim: et sw=2 sts=-1 tw=150 fdm=marker

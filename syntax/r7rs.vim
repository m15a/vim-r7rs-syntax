" Vim syntax file
" Language: Scheme (R7RS-small)
" Last change: 2020-06-03
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: MIT

if exists('b:current_syntax')
  finish
endif

let s:cpo = &cpo
set cpo&vim

" NOTE: This may cause slow down but accurate.
syn sync fromstart

" Options {{{1

" If (b|g):r7rs_strict is true, the following options are set to obey strict R7RS.
if !exists('b:r7rs_strict')
  let b:r7rs_strict = get(g:, 'r7rs_strict', 0)
endif

if !exists('b:r7rs_more_parens')
  let b:r7rs_more_parens = get(g:, 'r7rs_more_parens', ']')
endif
if !exists('b:r7rs_strict_identifier')
  let b:r7rs_strict_identifier = get(g:, 'r7rs_strict_identifier', 0)
endif

if b:r7rs_strict
  " Gauche allows [] and even {} to be parentheses, whereas R7RS does not.
  let s:use_brackets_as_parens = 0
  let s:use_braces_as_parens = 0
  " Gauche allows identifiers to begin with '.', [+-], or [0-9], whereas R7RS has some restriction.
  let s:use_strict_identifier = 1
else
  let s:use_strict_identifier = b:r7rs_strict_identifier
  let s:use_brackets_as_parens = match(b:r7rs_more_parens, '[\[\]]') != -1
  let s:use_braces_as_parens = match(b:r7rs_more_parens, '[()]') != -1
endif

" }}}

" Anything visible other than defined below are error.
syn match r7rsErr /[^[:space:]\n]/

" Comments and directives {{{1
syn cluster r7rsComs contains=r7rsCom,r7rsComNested,r7rsComSharp,r7rsDirective

" Comments {{{2
syn region r7rsCom start=/#\@<!;/ end=/$/
syn region r7rsComNested start=/#|/ end=/|#/ contains=r7rsComNested
" FIXME: highlight nested #;
" In `#; #; hello hello R7RS!`, the two `hello`s should be commented out but not.
syn region r7rsComSharp start=/#;/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contains=@r7rsComs skipwhite skipempty nextgroup=r7rsComDatum

" Comment out anything like literal identifier or number
syn match r7rsComDatum /#\?[^[:space:]\n|()";'`,\\#\[\]{}]\+/ contained
" Comment out character
syn match r7rsComDatum /#\\./ contained
syn match r7rsComDatum /#\\[^[:space:]\n|()";'`,\\#\[\]{}]\+/ contained
" Comment out enclosed identifier
syn region r7rsComDatum start=/|/ skip=/\\[\\|]/ end=/|/ contained
" Comment out string
syn region r7rsComDatum start=/"/ skip=/\\[\\"]/ end=/"/ contained
" Comment out label
syn match r7rsComDatum /#\d\+#/ contained
syn region r7rsComDatum start=/#\d\+=/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contained contains=@r7rsComs skipwhite skipempty nextgroup=r7rsComDatum
" Comment out parens
syn region r7rsComDatum start=/(/ end=/)/ contained contains=r7rsComDatum
syn region r7rsComDatum start=/\[/ end=/\]/ contained contains=r7rsComDatum
syn region r7rsComDatum start=/{/ end=/}/ contained contains=r7rsComDatum
" Move on when prefix before parens found
syn match r7rsComDatum /\(['`]\|,@\?\|#\([[:alpha:]]\d\+\)\?\ze(\)/ contained nextgroup=r7rsComDatum

" Directives (cf. R7RS, sec. 2.1 (p. 8) last paragraph) {{{2
syn match r7rsDirective /#!\%(no-\)\?fold-case/

" }}} }}}

" All data are classified into two types: quoted and non-quoted. Once a list or
" vector is quoted, its children are also quoted. As the children may not have
" ' or `, it is difficult to distinguish between them from their look.
" To highlight them differently, preparing two syntax groups is mandatory.
syn cluster r7rsData contains=@r7rsDataSimple,@r7rsDataCompound,r7rsLabel
syn cluster r7rsDataQ contains=@r7rsDataSimple,@r7rsDataCompoundQ,r7rsLabel

" Simple data (cf. R7RS, sec. 7.1.2) {{{1
syn cluster r7rsDataSimple contains=r7rsId,r7rsBool,r7rsNum,r7rsChar,r7rsStr,r7rsByteVec

" Identifiers (cf. R7RS, sec. 2.1 ,p. 62, and SmallErrata, 7) {{{2

" Those enclosed by |
syn region r7rsId matchgroup=r7rsDelim start=/|/ skip=/\\[\\|]/ end=/|/ contains=@r7rsEscChars

if s:use_strict_identifier
  " <initial> <subsequent>*
  " where <initial> -> [:alpha:] | [!$%&*\/:<=>?^_~@]
  "       <subsequent> -> [:alnum:] | [!$%&*\/:<=>?^_~@] | [.+-]
  syn match r7rsId /[[:alpha:]!$%&*\/:<=>?^_~@][[:alnum:]!$%&*\/:<=>?^_~@.+-]*/

  " Peculiar identifier case 1 and 2
  " [+-] | [+-] <sign subsequent> <subsequent>*
  " where <sign subsequent> = <initial> | [+-]
  syn match r7rsId /[+-]\%([[:alpha:]!$%&*\/:<=>?^_~@+-][[:alnum:]!$%&*\/:<=>?^_~@.+-]*\)\?/

  " Peculiar identifier case 3 and 4
  " [+-] . <dot subsequent> <subsequent>* | . <dot subsequent> <subsequent>*
  " where <dot subsequent> -> <initial> | [.+-]
  syn match r7rsId /[+-]\?\.[[:alpha:]!$%&*\/:<=>?^_~@.+-][[:alnum:]!$%&*\/:<=>?^_~@.+-]*/
else
  " Anything except single '.' is permitted.
  syn match r7rsId /\.[^[:space:]\n|()";'`,\\#\[\]{}]\+/
  syn match r7rsId /[^.[:space:]\n|()";'`,\\#\[\]{}][^[:space:]\n|()";'`,\\#\[\]{}]*/
endif

" Number (cf. R7RS, pp. 62-63) {{{2

" Note that alphabets are case-insensitive in numeric literals.

" Non-decimal number {{{3

" Real number {{{4
" ( #b | #[ei]#b | #b#[ei] )  " prefix #b and #[ei] can be swapped
" ( [+-]?[01]+(\/[01]+)?      " integer or rational
" | [+-](inf|nan)\.0          " inf or nan
" )
" Other radixes are analogous to the above binary case.
syn match r7rsNum /\v\c%(#b|#[ei]#b|#b#[ei])%([+-]?[01]+%(\/[01]+)?|[+-]%(inf|nan)\.0)>/
syn match r7rsNum /\v\c%(#o|#[ei]#o|#o#[ei])%([+-]?\o+%(\/\o+)?|[+-]%(inf|nan)\.0)>/
syn match r7rsNum /\v\c%(#x|#[ei]#x|#x#[ei])%([+-]?\x+%(\/\x+)?|[+-]%(inf|nan)\.0)>/

" Complex number in rectangular notation {{{4
" ( #b | #[ei]#b | #b#[ei] )
" ( [+-]?[01]+(\/[01]+)? | [+-](inf|nan)\.0 )?
" [+-]
" ( [01]+(\/[01]+)? | (inf|nan)\.0 )?
" i
syn match r7rsNum /\v\c%(#b|#[ei]#b|#b#[ei])%([+-]?[01]+%(\/[01]+)?|[+-]%(inf|nan)\.0)?[+-]%([01]+%(\/[01]+)?|%(inf|nan)\.0)?i>/
syn match r7rsNum /\v\c%(#o|#[ei]#o|#o#[ei])%([+-]?\o+%(\/\o+)?|[+-]%(inf|nan)\.0)?[+-]%(\o+%(\/\o+)?|%(inf|nan)\.0)?i>/
syn match r7rsNum /\v\c%(#x|#[ei]#x|#x#[ei])%([+-]?\x+%(\/\x+)?|[+-]%(inf|nan)\.0)?[+-]%(\x+%(\/\x+)?|%(inf|nan)\.0)?i>/

" Complex number in polar notation {{{4
" ( #b | #[ei]#b | #b#[ei] )
" ( [+-]?[01]+(\/[01]+)? | [+-](inf|nan)\.0 )
" \@
" ( [+-]?[01]+(\/[01]+)? | [+-](inf|nan)\.0 )
syn match r7rsNum /\v\c%(#b|#[ei]#b|#b#[ei])%([+-]?[01]+%(\/[01]+)?|[+-]%(inf|nan)\.0)\@%([+-]?[01]+%(\/[01]+)?|[+-]%(inf|nan)\.0)>/
syn match r7rsNum /\v\c%(#o|#[ei]#o|#o#[ei])%([+-]?\o+%(\/\o+)?|[+-]%(inf|nan)\.0)\@%([+-]?\o+%(\/\o+)?|[+-]%(inf|nan)\.0)>/
syn match r7rsNum /\v\c%(#x|#[ei]#x|#x#[ei])%([+-]?\x+%(\/\x+)?|[+-]%(inf|nan)\.0)\@%([+-]?\x+%(\/\x+)?|[+-]%(inf|nan)\.0)>/

" Decimal number {{{3

" Real number {{{4
" ( #[dei] | #[ei]#d | #d#[ei] )?  " no prefix or prefixed by #d, #[ei], #d#[ei], or #[ei]#d
" ( [+-]? ( \d+(\/\d+)?            " integer or rational
"         | ( \d+                  " fractional case 1
"           | \.\d+                " fractional case 2
"           | \d+\.\d*             " fractional case 3
"           )
"           ([esfdl][+-]\d+)?      " fractional number may have this suffix
"         )
" | [+-](inf|nan)\.0
" )
syn match r7rsNum /\v\c%(#[dei]|#[ei]#d|#d#[ei])?%([+-]?%(\d+%(\/\d+)?|%(\d+|\.\d+|\d+\.\d*)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)>/

" Complex number in rectangular notation {{{4
" ( #[dei] | #[ei]#d | #d#[ei] )?
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
syn match r7rsNum /\v\c%(#[dei]|#[ei]#d|#d#[ei])?%([+-]?%(\d+%(\/\d+)?|%(\d+|\.\d+|\d+\.\d*)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)?[+-]%(%(\d+%(\/\d+)?|%(\d+|\.\d+|\d+\.\d*)%([esfdl][+-]\d+)?)|%(inf|nan)\.0)?i>/

" Complex number in polar notation {{{4
" ( #[dei] | #[ei]#d | #d#[ei] )?
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
syn match r7rsNum /\v\c%(#[dei]|#[ei]#d|#d#[ei])?%([+-]?%(\d+%(\/\d+)?|%(\d+|\.\d+|\d+\.\d*)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)\@%([+-]?%(\d+%(\/\d+)?|%(\d+|\.\d+|\d+\.\d*)%([esfdl][+-]\d+)?)|[+-]%(inf|nan)\.0)>/

" Boolean {{{2
syn match r7rsBool /#t\%(rue\)\?/
syn match r7rsBool /#f\%(alse\)\?/

" Character {{{2
syn match r7rsChar /#\\./
syn match r7rsChar /#\\x\x\+/
syn match r7rsChar /#\\\%(alarm\|backspace\|delete\|escape\|newline\|null\|return\|space\|tab\)/

" String {{{2
syn region r7rsStr matchgroup=r7rsDelim start=/"/ skip=/\\[\\"]/ end=/"/ contains=@r7rsEscChars,r7rsEscWrap

" Escaped characters (embedded in \"strings\" and |identifiers|) {{{2
syn cluster r7rsEscChars contains=r7rsEscDelim,r7rsEscHex,r7rsEscMnemonic
syn match r7rsEscDelim /\\[\\|"]/ contained
syn match r7rsEscHex /\\x\x\+;/ contained
syn match r7rsEscMnemonic /\\[abtnr]/ contained

" This can be contained in strings but identifiers
syn match r7rsEscWrap /\\[[:space:]]*$/ contained

" Bytevectors {{{2
syn region r7rsByteVec matchgroup=r7rsDelim start=/#u8(/ end=/)/ contains=r7rsErr,@r7rsComs,r7rsNum

" Compound data (cf. R7RS, sec. 7.1.2) {{{1
syn cluster r7rsDataCompound contains=r7rsList,r7rsVec,r7rsQ,r7rsQQ
syn cluster r7rsDataCompoundQ contains=r7rsListQ,r7rsVecQ,r7rsQ,r7rsQQ

" Non-quoted lists and vector {{{2
syn region r7rsList matchgroup=r7rsDelim start=/#\@<!(/ end=/)/ contains=r7rsErr,@r7rsComs,@r7rsData,@r7rsExprs
if s:use_brackets_as_parens
  syn region r7rsList matchgroup=r7rsDelim start=/#\@<!\[/ end=/\]/ contains=r7rsErr,@r7rsComs,@r7rsData,@r7rsExprs
endif
if s:use_braces_as_parens
  syn region r7rsList matchgroup=r7rsDelim start=/#\@<!{/ end=/}/ contains=r7rsErr,@r7rsComs,@r7rsData,@r7rsExprs
endif
syn region r7rsVec matchgroup=r7rsDelim start=/#(/ end=/)/ contains=r7rsErr,@r7rsComs,@r7rsData,@r7rsExprs

" Apparently non-quoted but quoted lists and vector, as their ancestral parens are quoted {{{2
syn region r7rsListQ matchgroup=r7rsDelim start=/#\@<!(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ
if s:use_brackets_as_parens
  syn region r7rsListQ matchgroup=r7rsDelim start=/#\@<!\[/ end=/\]/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ
endif
if s:use_braces_as_parens
  syn region r7rsListQ matchgroup=r7rsDelim start=/#\@<!{/ end=/}/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ
endif
syn region r7rsVecQ matchgroup=r7rsDelim start=/#(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ

" Quoted simple data (any identifier, |identifier|, \"string\", or #-syntax other than '#(') {{{2
syn match r7rsQ /'\ze[^[:space:]\n();'`,\\#\[\]{}]/ nextgroup=r7rsDataSimple
syn match r7rsQ /'\ze#[^(]/ nextgroup=r7rsDataSimple

" Quoted lists and vector {{{2
syn match r7rsQ /'\ze(/ nextgroup=r7rsQList
syn region r7rsQList matchgroup=r7rsDelim start=/(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ
if s:use_brackets_as_parens
  syn match r7rsQ /'\ze\[/ nextgroup=r7rsQList
  syn region r7rsQList matchgroup=r7rsDelim start=/\[/ end=/\]/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ
endif
if s:use_braces_as_parens
  syn match r7rsQ /'\ze{/ nextgroup=r7rsQList
  syn region r7rsQList matchgroup=r7rsDelim start=/{/ end=/}/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ
endif
syn match r7rsQ /'\ze#(/ nextgroup=r7rsQVec
syn region r7rsQVec matchgroup=r7rsDelim start=/#(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ

" Quoted quotes {{{2
syn match r7rsQ /'\ze'/ nextgroup=r7rsQ
syn match r7rsQ /'\ze`/ nextgroup=r7rsQQ

" Quasiquoted simple data (any identifier, |idenfitier|, \"string\", or #-syntax other than '#(') {{{2
syn match r7rsQQ /`\ze[^[:space:]\n();'`,\\#\[\]{}]/ nextgroup=r7rsDataSimple
syn match r7rsQQ /`\ze#[^(]/ nextgroup=r7rsDataSimple

" Quasiquoted lists and vector {{{2
syn match r7rsQQ /`\ze(/ nextgroup=r7rsQQList
syn region r7rsQQList matchgroup=r7rsDelim start=/(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ,r7rsU
if s:use_brackets_as_parens
  syn match r7rsQQ /`\ze\[/ nextgroup=r7rsQQList
  syn region r7rsQQList matchgroup=r7rsDelim start=/\[/ end=/\]/ contains=r7rsErr,@r7rsComs,@r7rsDataQ,r7rsU
endif
if s:use_braces_as_parens
  syn match r7rsQQ /`\ze{/ nextgroup=r7rsQQList
  syn region r7rsQQList matchgroup=r7rsDelim start=/{/ end=/}/ contains=r7rsErr,@r7rsComs,@r7rsDataQ,r7rsU
endif
syn match r7rsQQ /`\ze#(/ nextgroup=r7rsQQVec
syn region r7rsQQVec matchgroup=r7rsDelim start=/#(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ,r7rsU

" Quasiquoted quotes {{{2
syn match r7rsQQ /`\ze'/ nextgroup=r7rsQ
syn match r7rsQQ /`\ze`/ nextgroup=r7rsQQ

" Unquote {{{2
" It allows comments before reaching any datum.
syn region r7rsU start=/,@\?/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contained contains=@r7rsComs skipwhite skipempty nextgroup=@r7rsData

" Dot '.' {{{2
syn keyword r7rsDot . contained containedin=r7rsList,r7rsListQ,r7rsQList,r7rsQQList

" Labels (cf. R7RS, sec. 2.4) {{{1
syn match r7rsLabel /#\d\+#/
syn region r7rsLabel start=/#\d\+=/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contains=@r7rsComs skipwhite skipempty nextgroup=@r7rsData

" Library declaration (cf. R7RS, sec. 5.6) {{{1
syn region r7rsLib matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*define-library/ end=/)/ contains=r7rsErr,@r7rsComs,r7rsLibSyn,r7rsLibName,@r7rsLibDecls
syn keyword r7rsLibSyn contained define-library export begin include include-ci include-library-declarations
syn keyword r7rsLibAux contained rename
syn region r7rsLibName matchgroup=r7rsDelim start=/(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsLibNameParts
syn cluster r7rsLibNameParts contains=r7rsId,r7rsUInt
syn match r7rsUInt /\d\+/ contained
syn cluster r7rsLibDecls contains=r7rsLibExport,r7rsImport,r7rsLibBegin,r7rsLibInclude,r7rsCondExpand
syn region r7rsLibExport matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*export/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsLibSyn,r7rsId,r7rsLibExportR
syn region r7rsLibExportR matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*rename/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsLibAux,r7rsId
" This 'begin' is different from normal 'begin' (cf. R7RS, secs. 5.6.1 and 4.2.3)
syn region r7rsLibBegin matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*begin/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsLibSyn,@r7rsData,@r7rsExprs
syn region r7rsLibInclude matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*include\%(-ci\|-library-declarations\)\?/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsLibSyn,r7rsStr

" Expressions (cf. R7RS, sec. 4) {{{1
syn cluster r7rsExprs contains=r7rsSyn,r7rsAux,r7rsCondExpand,r7rsImport,r7rsProc

syn keyword r7rsSyn quote lambda if set! include include-ci cond case and or when unless
syn keyword r7rsAux else =>

" cond-expand (cf. R7RS, p. 15) {{{2
syn region r7rsCondExpand matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*cond-expand/ end=/)/ contains=r7rsErr,@r7rsComs,r7rsCESyn,r7rsCEClause
syn keyword r7rsCESyn contained cond-expand and or not
syn keyword r7rsCEAux contained library
syn region r7rsCEClause matchgroup=r7rsDelim start=/(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsCEFeatures,@r7rsData
syn cluster r7rsCEFeatures contains=r7rsCEFeatureId,r7rsCEFeatureLib,r7rsCEFeatureAON,r7rsCEFeatureElse
syn keyword r7rsCEFeatureId r7rs exact-closed exact-complex ieee-float full-unicode ratios contained
syn keyword r7rsCEFeatureId posix windows unix darwin gnu-linux bsd freebsd solaris contained
syn keyword r7rsCEFeatureId i386 x86-64 ppc sparc jvm clr llvm contained
syn keyword r7rsCEFeatureId ilp32 lp64 ilp64 contained
syn keyword r7rsCEFeatureId big-endian little-endian contained
" TODO: add feature ids of Scheme implementations
" syn match r7rsCEFeatureId /\%(gauche\|chibi\|...\)/ contained
syn region r7rsCEFeatureLib matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*library/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsCEAux,r7rsLibName
syn region r7rsCEFeatureAON matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*\%(and\|or\|not\)/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsCESyn,@r7rsCEFeatures
syn keyword r7rsCEFeatureElse contained else

" import (cf. R7RS, sec. 5.2) {{{2
syn region r7rsImport matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*import/ end=/)/ contains=r7rsErr,@r7rsComs,r7rsImportSyn,@r7rsImportSets
syn keyword r7rsImportSyn contained import
syn keyword r7rsImportAux contained only except prefix rename
syn cluster r7rsImportSets contains=r7rsLibName,r7rsImportOEP,r7rsImportR
syn region r7rsImportOEP matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*\%(only\|except\|prefix\)/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsImportAux,@r7rsImportSets,r7rsId
syn region r7rsImportR matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*rename/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsImportAux,@r7rsImportSets,r7rsImportRList
syn region r7rsImportRList matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*(/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsImportRPair
syn region r7rsImportRPair matchgroup=r7rsDelim start=/(/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsId

" Highlights {{{1

hi def link r7rsErr Error
hi def link r7rsDelim Delimiter
hi def link r7rsCom Comment
hi def link r7rsComNested r7rsCom
hi def link r7rsComSharp r7rsCom
hi def link r7rsComDatum r7rsCom
hi def link r7rsDirective Comment
hi def link r7rsId Normal
hi def link r7rsNum Number
hi def link r7rsUInt r7rsNum
hi def link r7rsBool Boolean
hi def link r7rsChar Character
hi def link r7rsCharM SpecialChar
hi def link r7rsStr String
hi def link r7rsEscDelim r7rsChar
hi def link r7rsEscHex r7rsChar
hi def link r7rsEscMnemonic r7rsCharM
hi def link r7rsEscWrap r7rsCharM
hi def link r7rsQ r7rsSyn
hi def link r7rsQQ r7rsSyn
hi def link r7rsU r7rsAux
hi def link r7rsDot r7rsAux
hi def link r7rsLabel Underlined
hi def link r7rsSynM PreProc
hi def link r7rsSyn Statement
hi def link r7rsAux Special
hi def link r7rsLibSyn r7rsSynM
hi def link r7rsLibAux r7rsAux
hi def link r7rsCESyn r7rsLibSyn
hi def link r7rsCEAux r7rsLibAux
hi def link r7rsCEFeatureId Tag
hi def link r7rsCEFeatureElse r7rsCEAux
hi def link r7rsImportSyn r7rsLibSyn
hi def link r7rsImportAux r7rsLibAux

" }}}

let b:current_syntax = 'r7rs'

let &cpo = s:cpo
unlet s:cpo

" vim: et sw=2 sts=-1 tw=0 fdm=marker

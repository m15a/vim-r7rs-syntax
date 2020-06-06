" Vim syntax file
" Language: Scheme (Gauche)
" Last Change: 2020-06-06
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: MIT

if !exists('b:did_r7rs_syntax')
  finish
endif

" Options {{{1

if get(b:, 'r7rs_strict', get(g:, 'r7rs_strict', 0))
  let s:brackets_as_parens = 0
  let s:braces_as_parens = 0
else
  let s:more_parens = get(b:, 'r7rs_more_parens', get(g:, 'r7rs_more_parens', ']'))
  let s:brackets_as_parens = match(s:more_parens, '[\[\]]') > -1
  let s:braces_as_parens = match(s:more_parens, '[{}]') > -1
  unlet s:more_parens
endif

" }}}

" Comments and directives {{{1
syn cluster r7rsComs add=gaucheShebang,gaucheDirective,gaucheDebug

" Comments {{{2

" Comment out character set (':]' is contained in POSIX character set)
syn region r7rsComDatum start=/#\[/ skip=/\\[\\\]]/ end=/\]/ contained contains=gaucheComDatumPOSIX
syn region gaucheComDatumPOSIX start=/\\\@<!\[:/ end=/:\]/ contained
" Comment out regular expression ('/' is contained in character set)
syn region r7rsComDatum start=/#\// skip=/\\[\\\/]/ end=/\/i\?/ contained contains=gaucheComDatumCS
syn region gaucheComDatumCS start=/\\\@<!\[/ skip=/\\[\\\]]/ end=/\]/ contained contains=gaucheComDatumPOSIX
" Comment out incomplete/interpolated string
syn region r7rsComDatum start=/#\*\?"/ skip=/\\[\\"]/ end=/"/ contained

" Directives {{{2
syn match gaucheShebang /\%^#![\/ ].*$/
syn match gaucheDirective /#!\(gauche-legacy\|r[67]rs\)/

" Debug directive {{{2
syn match gaucheDebug /#?[,=]/

" Simple data {{{1
syn cluster r7rsDataSimple remove=r7rsBVec
syn cluster r7rsDataSimple add=gaucheKey,gaucheNum,gaucheChar,gaucheCharSet,gaucheRegExp,gaucheStrI,gaucheStrQQ,gaucheUVec,gaucheClass

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

" Regular expression {{{2
syn region gaucheRegExp matchgroup=r7rsDelim start=/#\// skip=/\\[\\\/]/ end=/\/i\?/ contains=@gaucheRESyntax
syn cluster gaucheRESyntax contains=gaucheRECapture,gaucheREPattern,@gaucheREEscChars,gaucheCSSpec
syn region gaucheRECapture matchgroup=gaucheREEscMeta start=/\\\@<!(?\@<!/ skip=/\\[\\)]/ end=/)/ contained contains=@gaucheRESyntax
syn region gaucheRECapture matchgroup=gaucheREEscMeta start=/\\\@<!(?\%(:\|-\?i:\|<\%(\\>\|[^>=!]\)*>\)/ skip=/\\[\\)]/ end=/)/ contained contains=@gaucheRESyntax
syn region gaucheRECapture matchgroup=gaucheREEscMeta start=/\\\@<!(?\((\d\+)\|(?<\?[=!]\)\@=/ skip=/\\[\\)]/ end=/)/ contained contains=@gaucheRESyntax
syn region gaucheREPattern matchgroup=gaucheREEscMeta start=/\\\@<!(?\%(<\?[=!]\|>\)/ skip=/\\[\\)]/ end=/)/ contained contains=@gaucheRESyntax

" Escaped characters (embedded in #/regular expression/) {{{2
syn cluster gaucheREEscChars contains=gaucheREEscMeta,r7rsEscHex,gaucheREEscMnemonic,gaucheREEscLiteral
" FIXME: ^ should be highlighted only after #/, (?=, etc. $ is more complex, hmm.
syn match gaucheREEscMeta /\\\@<![*+?.|^$]/ contained
syn match gaucheREEscMeta /\v\{%(\d+)?%(,)?%(\d+)?\}/ contained
syn match gaucheREEscMeta /\\\d\+/ contained
syn match gaucheREEscMeta /\\k<\(\\>\|[^>]\)*>/ contained
syn match gaucheREEscMnemonic /\\[sSdDwWbB]/ contained
syn match gaucheREEscLiteral /\\[\\*+?.{,}|^$:=!<>\[\];"#/]/ contained

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

" Class and condition type {{{2
syn match gaucheClass /<[^[:space:]\n|()";'`,\\#\[\]{}]\+>/
syn match gaucheClass /&[^[:space:]\n|()";'`,\\#\[\]{}]\+/

" }}} }}}

" Expressions
syn cluster r7rsExprs add=gaucheSyn,gaucheSynM

" Common expressions {{{1

syn keyword gaucheLibSyn define-module
syn keyword gaucheLibSyn export-all
syn keyword gaucheLibSyn require
syn keyword gaucheLibSyn select-module
syn keyword gaucheSyn $
syn keyword gaucheSyn %macroexpand
syn keyword gaucheSyn %macroexpand-1
syn keyword gaucheSyn ^
syn keyword gaucheSyn add-load-path
syn keyword gaucheSyn address-family
syn keyword gaucheSyn address-info
syn keyword gaucheSyn and-let*
syn keyword gaucheSyn and-let1
syn keyword gaucheSyn any?-ec
syn keyword gaucheSyn append-ec
syn keyword gaucheSyn apropos
syn keyword gaucheSyn assume
syn keyword gaucheSyn assume-type
syn keyword gaucheSyn autoload
syn keyword gaucheSyn begin0
syn keyword gaucheSyn cgen-with-cpp-condition
syn keyword gaucheSyn chibi-test
syn keyword gaucheSyn cond-list
syn keyword gaucheSyn condition
syn keyword gaucheSyn current-module
syn keyword gaucheSyn cut
syn keyword gaucheSyn cute
syn keyword gaucheSyn debug-funcall
syn keyword gaucheSyn debug-print
syn keyword gaucheSyn do-ec
syn keyword gaucheSyn do-generator
syn keyword gaucheSyn dolist
syn keyword gaucheSyn dotimes
syn keyword gaucheSyn dynamic-lambda
syn keyword gaucheSyn ecase
syn keyword gaucheSyn endianness
syn keyword gaucheSyn er-macro-transformer
syn keyword gaucheSyn every?-ec
syn keyword gaucheSyn extend
syn keyword gaucheSyn first-ec
syn keyword gaucheSyn fluid-let
syn keyword gaucheSyn fold-ec
syn keyword gaucheSyn fold3-ec
syn keyword gaucheSyn get-keyword*
syn keyword gaucheSyn get-optional
syn keyword gaucheSyn glet*
syn keyword gaucheSyn glet1
syn keyword gaucheSyn if-let1
syn keyword gaucheSyn if-not=?
syn keyword gaucheSyn if3
syn keyword gaucheSyn if<=?
syn keyword gaucheSyn if<?
syn keyword gaucheSyn if=?
syn keyword gaucheSyn if>=?
syn keyword gaucheSyn if>?
syn keyword gaucheSyn ip-protocol
syn keyword gaucheSyn last-ec
syn keyword gaucheSyn lazy
syn keyword gaucheSyn lcons
syn keyword gaucheSyn lcons*
syn keyword gaucheSyn let-args
syn keyword gaucheSyn let-keywords
syn keyword gaucheSyn let-keywords*
syn keyword gaucheSyn let-optionals*
syn keyword gaucheSyn let-string-start+end
syn keyword gaucheSyn let/cc
syn keyword gaucheSyn let1
syn keyword gaucheSyn list-ec
syn keyword gaucheSyn llist*
syn keyword gaucheSyn make-option-parser
syn keyword gaucheSyn match
syn keyword gaucheSyn match-define
syn keyword gaucheSyn match-lambda
syn keyword gaucheSyn match-lambda*
syn keyword gaucheSyn match-let
syn keyword gaucheSyn match-let*
syn keyword gaucheSyn match-let1
syn keyword gaucheSyn match-letrec
syn keyword gaucheSyn max-ec
syn keyword gaucheSyn message-type
syn keyword gaucheSyn min-ec
syn keyword gaucheSyn parse-options
syn keyword gaucheSyn product-ec
syn keyword gaucheSyn quasirename
syn keyword gaucheSyn rec
syn keyword gaucheSyn receive
syn keyword gaucheSyn require-extension
syn keyword gaucheSyn reset
syn keyword gaucheSyn rlet1
syn keyword gaucheSyn rx
syn keyword gaucheSyn rxmatch-case
syn keyword gaucheSyn rxmatch-cond
syn keyword gaucheSyn rxmatch-if
syn keyword gaucheSyn rxmatch-let
syn keyword gaucheSyn shift
syn keyword gaucheSyn shutdown-method
syn keyword gaucheSyn socket-domain
syn keyword gaucheSyn ssax:make-elem-parser
syn keyword gaucheSyn ssax:make-parser
syn keyword gaucheSyn ssax:make-pi-parser
syn keyword gaucheSyn stream
syn keyword gaucheSyn stream+
syn keyword gaucheSyn stream-cons
syn keyword gaucheSyn stream-delay
syn keyword gaucheSyn stream-lambda
syn keyword gaucheSyn stream-let
syn keyword gaucheSyn stream-match
syn keyword gaucheSyn stream-of
syn keyword gaucheSyn string-append-ec
syn keyword gaucheSyn string-ec
syn keyword gaucheSyn sum-ec
syn keyword gaucheSyn syntax-errorf
syn keyword gaucheSyn test*
syn keyword gaucheSyn time
syn keyword gaucheSyn unquote
syn keyword gaucheSyn unquote-splicing
syn keyword gaucheSyn until
syn keyword gaucheSyn unwind-protect
syn keyword gaucheSyn values->list
syn keyword gaucheSyn values-ref
syn keyword gaucheSyn vector-ec
syn keyword gaucheSyn vector-of-length-ec
syn keyword gaucheSyn while
syn keyword gaucheSyn with-builder
syn keyword gaucheSyn with-cf-subst
syn keyword gaucheSyn with-iterator
syn keyword gaucheSyn with-module
syn keyword gaucheSyn with-signal-handlers
syn keyword gaucheSyn with-time-counter
syn keyword gaucheSyn xml-token-head
syn keyword gaucheSyn xml-token-kind
syn keyword gaucheSynM dec!
syn keyword gaucheSynM define-cise-expr
syn keyword gaucheSynM define-cise-macro
syn keyword gaucheSynM define-cise-stmt
syn keyword gaucheSynM define-cise-toplevel
syn keyword gaucheSynM define-class
syn keyword gaucheSynM define-condition-type
syn keyword gaucheSynM define-constant
syn keyword gaucheSynM define-dict-interface
syn keyword gaucheSynM define-generic
syn keyword gaucheSynM define-in-module
syn keyword gaucheSynM define-inline
syn keyword gaucheSynM define-macro
syn keyword gaucheSynM define-method
syn keyword gaucheSynM define-stream
syn keyword gaucheSynM inc!
syn keyword gaucheSynM pop!
syn keyword gaucheSynM push!
syn keyword gaucheSynM set!-values
syn keyword gaucheSynM update!
syn match gaucheSyn /\^[_a-z]/

" Special expressions {{{1

" Hybrid 'import' {{{2
syn region gaucheImport matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*import[[:space:]\n]\+[^(\[{]/ end=/)/ contains=r7rsErr,@r7rsComs,r7rsImportSyn,@gaucheImportSets
syn cluster gaucheImportSets contains=r7rsId,gaucheImportOER,gaucheImportP
syn region gaucheImportOER matchgroup=gaucheKey start=/:\(only\|except\|rename\)/ end=/\ze[[:space:]\n]*[:)\]}]/ contained contains=r7rsErr,@r7rsComs,r7rsImportList
syn region gaucheImportP matchgroup=gaucheKey start=/:prefix/ end=/\ze[[:space:]\n]*[:)\]}]/ contained contains=r7rsErr,@r7rsComs,r7rsId
if s:brackets_as_parens
  syn region gaucheImport matchgroup=r7rsDelim start=/\[\ze[[:space:]\n]*import[[:space:]\n]\+[^(\[{]/ end=/\]/ contains=r7rsErr,@r7rsComs,r7rsImportSyn,@gaucheImportSets
endif
if s:braces_as_parens
  syn region gaucheImport matchgroup=r7rsDelim start=/{\ze[[:space:]\n]*import[[:space:]\n]\+[^(\[{]/ end=/}/ contains=r7rsErr,@r7rsComs,r7rsImportSyn,@gaucheImportSets
endif

" 'use' {{{2
syn region gaucheUse matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*use/ end=/)/ contains=r7rsErr,@r7rsComs,gaucheUseSyn,@gaucheImportSets
syn keyword gaucheUseSyn use
if s:brackets_as_parens
  syn region gaucheUse matchgroup=r7rsDelim start=/\[\ze[[:space:]\n]*use/ end=/\]/ contains=r7rsErr,@r7rsComs,gaucheUseSyn,@gaucheImportSets
endif
if s:braces_as_parens
  syn region gaucheUse matchgroup=r7rsDelim start=/{\ze[[:space:]\n]*use/ end=/}/ contains=r7rsErr,@r7rsComs,gaucheUseSyn,@gaucheImportSets
endif

" 'export' can be used outside 'define-library' {{{2
syn match gaucheExport /\ze[(\[{][[:space:]\n]*export\>/ nextgroup=r7rsLibExport

" Highlights {{{1

hi def link gaucheComDatumPOSIX r7rsCom
hi def link gaucheComDatumCS r7rsCom
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
hi def link gaucheRegExp r7rsStr
hi def link gaucheRECapture r7rsStr
hi def link gaucheREPattern r7rsStr
hi def link gaucheREEscMeta r7rsCharM
hi def link gaucheREEscMnemonic r7rsEscMnemonic
hi def link gaucheREEscLiteral r7rsEscLiteral
hi def link gaucheStrI r7rsStr
hi def link gaucheStrQQ r7rsStr
hi def link gaucheStrQQU r7rsU
hi def link gaucheEscHex r7rsEscHex
hi def link gaucheEscMnemonic r7rsEscMnemonic
hi def link gaucheClass Type
hi def link gaucheLibSyn r7rsLibSyn
hi def link gaucheUseSyn r7rsSynM
hi def link gaucheSyn r7rsSyn
hi def link gaucheSynM r7rsSynM

" }}}

" vim: et sw=2 sts=-1 tw=100 fdm=marker

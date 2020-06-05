" Vim syntax file
" Language: Scheme (R7RS-small)
" Last Change: 2020-06-05
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-gauche-syntax
" License: MIT

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

if !exists('b:r7rs_more_parens')
  let b:r7rs_more_parens = get(g:, 'r7rs_more_parens', ']')
endif
if !exists('b:r7rs_strict_identifier')
  let b:r7rs_strict_identifier = get(g:, 'r7rs_strict_identifier', 0)
endif

if b:r7rs_strict
  " Gauche allows [] and even {} to be parentheses, whereas R7RS does not.
  let b:r7rs_brackets_as_parens = 0
  let b:r7rs_braces_as_parens = 0
  " Gauche allows identifiers to begin with '.', [+-], or [0-9], whereas R7RS has some restriction.
  let b:r7rs_strict_identifier = 1
else
  let b:r7rs_brackets_as_parens = match(b:r7rs_more_parens, '[\[\]]') != -1
  let b:r7rs_braces_as_parens = match(b:r7rs_more_parens, '[{}]') != -1
  let b:r7rs_strict_identifier = b:r7rs_strict_identifier
endif

" }}}

" This may cause slow down but provide accurate syntax highlight.
syn sync fromstart

" Anything visible other than defined below are error.
syn match r7rsErr /[^[:space:]\n]/

" Comments and directives {{{1
syn cluster r7rsComs contains=r7rsCom,r7rsComNested,r7rsComSharp,r7rsDirective

" Comments {{{2
syn region r7rsCom start=/#\@<!;/ end=/$/ contains=r7rsComTodo
syn region r7rsComNested start=/#|/ end=/|#/ contains=r7rsComNested,r7rsComTodo
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

syntax match r7rsComTodo /\c^[[:space:]]*\(FIXME\|TODO\|NOTE\):/ contained

" Directives (cf. R7RS, sec. 2.1 (p. 8) last paragraph) {{{2
syn match r7rsDirective /#!\%(no-\)\?fold-case/

" }}} }}}

" All data are classified into three types: unquoted, quoted, and quasiquoted.
" Once a list or vector is (quasi)quoted, its children are also (quasi)quoted.
" As the children may not be prefixed by ' or `, it is difficult to distinguish
" between them from their look. To highlight them differently, preparing three
" syntax groups is mandatory.
syn cluster r7rsData contains=@r7rsDataSimple,@r7rsDataCompound,r7rsLabel
syn cluster r7rsDataQ contains=@r7rsDataSimple,@r7rsDataCompoundQ,r7rsLabel
syn cluster r7rsDataQQ contains=@r7rsDataSimple,@r7rsDataCompoundQQ,r7rsLabel

" Simple data (cf. R7RS, sec. 7.1.2) {{{1
syn cluster r7rsDataSimple contains=r7rsId,r7rsBool,r7rsNum,r7rsChar,r7rsStr,r7rsBVec

" Identifiers (cf. R7RS, sec. 2.1 ,p. 62, and SmallErrata, 7) {{{2

" Those enclosed by |
syn region r7rsId matchgroup=r7rsDelim start=/|/ skip=/\\[\\|]/ end=/|/ contains=@r7rsEscChars

if b:r7rs_strict_identifier
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

" NOTE: alphabets are case-insensitive in numeric literals.

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
syn cluster r7rsEscChars contains=r7rsEscLiteral,r7rsEscHex,r7rsEscMnemonic
syn match r7rsEscLiteral /\\[\\|"]/ contained
syn match r7rsEscHex /\\x\x\+;/ contained
syn match r7rsEscMnemonic /\\[abtnr]/ contained

" This can be contained in strings but identifiers
syn match r7rsEscWrap /\\[[:space:]]*$/ contained

" Bytevectors {{{2
syn region r7rsBVec matchgroup=r7rsDelim start=/#u8(/ end=/)/ contains=r7rsErr,@r7rsComs,r7rsNum

" Compound data (cf. R7RS, sec. 7.1.2) {{{1
syn cluster r7rsDataCompound contains=r7rsList,r7rsVec,r7rsQ,r7rsQQ
syn cluster r7rsDataCompoundQ contains=r7rsListQ,r7rsVecQ,r7rsQ,r7rsQQ
syn cluster r7rsDataCompoundQQ contains=r7rsListQQ,r7rsVecQQ,r7rsQ,r7rsQQ

" Unquoted lists and vector {{{2
syn region r7rsList matchgroup=r7rsDelim start=/#\@<!(/ end=/)/ contains=r7rsErr,@r7rsComs,@r7rsData,@r7rsExprs
if b:r7rs_brackets_as_parens
  syn region r7rsList matchgroup=r7rsDelim start=/#\@<!\[/ end=/\]/ contains=r7rsErr,@r7rsComs,@r7rsData,@r7rsExprs
endif
if b:r7rs_braces_as_parens
  syn region r7rsList matchgroup=r7rsDelim start=/#\@<!{/ end=/}/ contains=r7rsErr,@r7rsComs,@r7rsData,@r7rsExprs
endif
syn region r7rsVec matchgroup=r7rsDelim start=/#(/ end=/)/ contains=r7rsErr,@r7rsComs,@r7rsData,@r7rsExprs

" Apparently unquoted but quoted lists and vector {{{2
syn region r7rsListQ matchgroup=r7rsDelim start=/#\@<!(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ
if b:r7rs_brackets_as_parens
  syn region r7rsListQ matchgroup=r7rsDelim start=/#\@<!\[/ end=/\]/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ
endif
if b:r7rs_braces_as_parens
  syn region r7rsListQ matchgroup=r7rsDelim start=/#\@<!{/ end=/}/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ
endif
syn region r7rsVecQ matchgroup=r7rsDelim start=/#(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ

" Apparently unquoted but quasiquoted lists and vector {{{2
syn region r7rsListQQ matchgroup=r7rsDelim start=/#\@<!(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQQ,r7rsU
if b:r7rs_brackets_as_parens
  syn region r7rsListQQ matchgroup=r7rsDelim start=/#\@<!\[/ end=/\]/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQQ,r7rsU
endif
if b:r7rs_braces_as_parens
  syn region r7rsListQQ matchgroup=r7rsDelim start=/#\@<!{/ end=/}/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQQ,r7rsU
endif
syn region r7rsVecQQ matchgroup=r7rsDelim start=/#(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQQ,r7rsU

" Quoted simple data (any identifier, |identifier|, \"string\", or #-syntax other than '#(') {{{2
syn match r7rsQ /'\ze[^[:space:]\n();'`,\\#\[\]{}]/ nextgroup=r7rsDataSimple
syn match r7rsQ /'\ze#[^(]/ nextgroup=r7rsDataSimple

" Quoted lists and vector {{{2
syn match r7rsQ /'\ze(/ nextgroup=r7rsQList
syn region r7rsQList matchgroup=r7rsDelim start=/(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ
if b:r7rs_brackets_as_parens
  syn match r7rsQ /'\ze\[/ nextgroup=r7rsQList
  syn region r7rsQList matchgroup=r7rsDelim start=/\[/ end=/\]/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQ
endif
if b:r7rs_braces_as_parens
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
syn region r7rsQQList matchgroup=r7rsDelim start=/(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQQ,r7rsU
if b:r7rs_brackets_as_parens
  syn match r7rsQQ /`\ze\[/ nextgroup=r7rsQQList
  syn region r7rsQQList matchgroup=r7rsDelim start=/\[/ end=/\]/ contains=r7rsErr,@r7rsComs,@r7rsDataQQ,r7rsU
endif
if b:r7rs_braces_as_parens
  syn match r7rsQQ /`\ze{/ nextgroup=r7rsQQList
  syn region r7rsQQList matchgroup=r7rsDelim start=/{/ end=/}/ contains=r7rsErr,@r7rsComs,@r7rsDataQQ,r7rsU
endif
syn match r7rsQQ /`\ze#(/ nextgroup=r7rsQQVec
syn region r7rsQQVec matchgroup=r7rsDelim start=/#(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsDataQQ,r7rsU

" Quasiquoted (un)quotes {{{2
syn match r7rsQQ /`\ze'/ nextgroup=r7rsQ
syn match r7rsQQ /`\ze`/ nextgroup=r7rsQQ
syn match r7rsQQ /`\ze,@\?/ nextgroup=r7rsU

" Unquote {{{2
" It allows comments before reaching any datum.
syn region r7rsU start=/,@\?/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contained contains=@r7rsComs skipwhite skipempty nextgroup=@r7rsData

" Dot '.' {{{2
syn keyword r7rsDot . contained containedin=r7rsList,r7rsListQ,r7rsListQQ,r7rsQList,r7rsQQList

" Labels (cf. R7RS, sec. 2.4) {{{1
syn match r7rsLabel /#\d\+#/
syn region r7rsLabel start=/#\d\+=/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contains=@r7rsComs skipwhite skipempty nextgroup=@r7rsData

" Common expressions (cf. R7RS, sec. 4) {{{1
syn cluster r7rsExprs contains=r7rsSyn,r7rsSynM,r7rsAux,r7rsProc,r7rsCondExpand,r7rsImport

" R7RS, sec. 4.1 {{{2
syn keyword r7rsSyn quote lambda if
syn keyword r7rsSynM set! include include-ci

" R7RS, sec. 4.2.1 - 4.2.4 {{{2

syn keyword r7rsSyn cond case and or when unless let let* letrec letrec* let-values let*-values begin do
syn keyword r7rsAux else =>

" R7RS, sec. 4.2.5 - 4.2.9 {{{2

syn keyword r7rsSyn delay delay-force parameterize guard quasiquote case-lambda
syn keyword r7rsProc force promise? make-promiss make-parameter
syn keyword r7rsAux unquote unquote-splicing

" R7RS, sec. 4.3 {{{2

syn keyword r7rsSynM let-syntax letrec-syntax syntax-rules syntax-error
syn keyword r7rsAux _ ...

" R7RS, sec. 5.1 - 5.5 {{{2

syn keyword r7rsSynM define define-values define-syntax define-record-type

" R7RS, sec. 6.1 {{{2
syn keyword r7rsProc eqv? eq? equal?

" R7RS, sec. 6.2 {{{2
syn keyword r7rsProc number? complex? real? rational? integer? exact? inexact? exact-integer? finite? infinite? nan? = < > <= >= zero? positive?
syn keyword r7rsProc negative? odd? even? max min + * - / abs floor/ floor-quotient floor-remainder truncate/ truncate-quotient truncate-remainder
syn keyword r7rsProc quotient remainder modulo gcd lcm numerator denominator floor ceiling truncate round rationalize exp log sin cos tan asin acos
syn keyword r7rsProc atan square sqrt exact-integer-sqrt expt make-rectangular make-polar real-part imag-part magnitude angle inexact exact
syn keyword r7rsProc number->string string->number

" R7RS, sec. 6.3 {{{2
syn keyword r7rsProc not boolean? boolean=?

" R7RS, sec. 6.4 {{{2
syn keyword r7rsProc pair? cons car cdr caar cdar cadr cddr caaar cdaar cadar cddar caadr cdadr caddr cdddr
syn keyword r7rsProc caaaar cdaaar cadaar cddaar caadar cdadar caddar cdddar caaadr cdaadr cadadr cddadr caaddr cdaddr cadddr cddddr
syn keyword r7rsProc null? list? make-list list length append reverse list-tail list-ref memq memv member assq assv assoc list-copy
syn keyword r7rsProcM set-car! set-cdr! list-set!

" R7RS, sec. 6.5 {{{2
syn keyword r7rsProc symbol? symbol=? symbol->string string->symbol

" R7RS, sec. 6.6 {{{2
syn keyword r7rsProc char? char=? char<? char>? char<=? char>=? char-ci=? char-ci<? char-ci>? char-ci<=? char-ci>=?
syn keyword r7rsProc char-alphabetic? char-numeric? char-whitespace? char-upper-case? char-lower-case? digit-value char->integer integer->char
syn keyword r7rsProc char-upcase char-downcase char-foldcase

" R7RS, sec. 6.7 {{{2
syn keyword r7rsProc string? make-string string string-length string-ref
syn keyword r7rsProc string=? string-ci=? string<? string-ci<? string>? string-ci>? string<=? string-ci<=? string>=? string-ci>=?
syn keyword r7rsProc string-upcase string-downcase string-foldcase
syn keyword r7rsProc substring string-append string->list list->string string-copy
syn keyword r7rsProcM string-set! string-copy! string-fill!

" R7RS, sec. 6.8 {{{2
syn keyword r7rsProc vector? make-vector vector vector-length vector-ref vector->list list->vector vector->string string->vector vector-copy
syn keyword r7rsProc vector-append
syn keyword r7rsProcM vector-set! vector-copy! vector-fill!

" R7RS, sec. 6.9 {{{2
syn keyword r7rsProc bytevector? make-bytevector bytevector bytevector-length bytevector-u8-ref bytevector-copy bytevector-append utf8->string
syn keyword r7rsProc string->utf8
syn keyword r7rsProcM bytevector-u8-set! bytevector-copy!

" R7RS, sec. 6.10 {{{2
syn keyword r7rsProc procedure? apply map string-map vector-map for-each string-for-each vector-for-each
syn keyword r7rsProc call-with-current-continuation call/cc values call-with-values dynamic-wind

" R7RS, sec. 6.11 {{{2
syn keyword r7rsProc with-exception-handler raise raise-continuable error error-object? error-object-message error-object-irritants
syn keyword r7rsProc read-error? file-error?

" R7RS, sec. 6.12 {{{2
syn keyword r7rsProc environment scheme-report-environment null-environment interaction-environment eval

" R7RS, sec. 6.13 {{{2
syn keyword r7rsProc call-with-port call-with-input-file call-with-output-file
syn keyword r7rsProc input-port? output-port? textual-port? binary-port? port? input-port-open? output-port-open?
syn keyword r7rsProc current-input-port current-output-port current-error-port
syn keyword r7rsProc with-input-from-file with-output-to-file open-input-file open-binary-input-file open-output-file open-binary-output-file
syn keyword r7rsProc close-port close-input-port close-output-port
syn keyword r7rsProc open-input-string open-output-string get-output-string open-input-bytevector open-output-bytevector get-output-bytevector
syn keyword r7rsProc read read-char peek-char read-line eof-object? eof-object char-ready? read-string read-u8 peek-u8 u8-ready?
syn keyword r7rsProc read-bytevector
syn keyword r7rsProc write write-shared write-simple display newline write-char write-string write-u8 write-bytevector flush-output-port
syn keyword r7rsProcM read-bytevector!

" R7RS, sec. 6.14 {{{2
syn keyword r7rsProc file-exists? delete-file command-line exit emergency-exit get-environment-variable get-environment-variables
syn keyword r7rsProc current-second current-jiffy jiffies-per-second features
syn keyword r7rsProcM load

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
if b:r7rs_brackets_as_parens
  syn region r7rsLib matchgroup=r7rsDelim start=/\[\ze[[:space:]\n]*define-library/ end=/\]/ contains=r7rsErr,@r7rsComs,r7rsLibSyn,r7rsLibName,@r7rsLibDecls
  syn region r7rsLibName matchgroup=r7rsDelim start=/\[/ end=/\]/ contained contains=r7rsErr,@r7rsComs,@r7rsLibNameParts
  syn region r7rsLibExport matchgroup=r7rsDelim start=/\[\ze[[:space:]\n]*export/ end=/\]/ contained contains=r7rsErr,@r7rsComs,r7rsLibSyn,r7rsId,r7rsLibExportR
  syn region r7rsLibExportR matchgroup=r7rsDelim start=/\[\ze[[:space:]\n]*rename/ end=/\]/ contained contains=r7rsErr,@r7rsComs,r7rsLibAux,r7rsId
  syn region r7rsLibBegin matchgroup=r7rsDelim start=/\[\ze[[:space:]\n]*begin/ end=/\]/ contained contains=r7rsErr,@r7rsComs,r7rsLibSyn,@r7rsData,@r7rsExprs
  syn region r7rsLibInclude matchgroup=r7rsDelim start=/\[\ze[[:space:]\n]*include\%(-ci\|-library-declarations\)\?/ end=/\]/ contained contains=r7rsErr,@r7rsComs,r7rsLibSyn,r7rsStr
endif
if b:r7rs_braces_as_parens
  syn region r7rsLib matchgroup=r7rsDelim start=/{\ze[[:space:]\n]*define-library/ end=/}/ contains=r7rsErr,@r7rsComs,r7rsLibSyn,r7rsLibName,@r7rsLibDecls
  syn region r7rsLibName matchgroup=r7rsDelim start=/{/ end=/}/ contained contains=r7rsErr,@r7rsComs,@r7rsLibNameParts
  syn region r7rsLibExport matchgroup=r7rsDelim start=/{\ze[[:space:]\n]*export/ end=/}/ contained contains=r7rsErr,@r7rsComs,r7rsLibSyn,r7rsId,r7rsLibExportR
  syn region r7rsLibExportR matchgroup=r7rsDelim start=/{\ze[[:space:]\n]*rename/ end=/}/ contained contains=r7rsErr,@r7rsComs,r7rsLibAux,r7rsId
  syn region r7rsLibBegin matchgroup=r7rsDelim start=/{\ze[[:space:]\n]*begin/ end=/}/ contained contains=r7rsErr,@r7rsComs,r7rsLibSyn,@r7rsData,@r7rsExprs
  syn region r7rsLibInclude matchgroup=r7rsDelim start=/{\ze[[:space:]\n]*include\%(-ci\|-library-declarations\)\?/ end=/}/ contained contains=r7rsErr,@r7rsComs,r7rsLibSyn,r7rsStr
endif

" Special expressions that override general ones {{{1

" cond-expand (cf. R7RS, p. 15) {{{2
syn region r7rsCondExpand matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*cond-expand/ end=/)/ contains=r7rsErr,@r7rsComs,r7rsCESyn,r7rsCEClause
syn keyword r7rsCESyn contained cond-expand and or not
syn keyword r7rsCEAux contained library
syn region r7rsCEClause matchgroup=r7rsDelim start=/(/ end=/)/ contained contains=r7rsErr,@r7rsComs,@r7rsCEFeatures,@r7rsData
syn cluster r7rsCEFeatures contains=r7rsCEFeatureId,r7rsCEFeatureLib,r7rsCEFeatureAON,r7rsCEFeatureElse
syn keyword r7rsCEFeatureId r7rs exact-closed exact-complex ieee-float full-unicode ratios contained
syn keyword r7rsCEFeatureId posix windows dos unix darwin gnu-linux bsd freebsd solaris contained
syn keyword r7rsCEFeatureId i386 x86-64 ppc sparc jvm clr llvm contained
syn keyword r7rsCEFeatureId ilp32 lp64 ilp64 contained
syn keyword r7rsCEFeatureId big-endian little-endian contained
syn keyword r7rsCEFeatureId debug contained
" Scheme implementations found in schemepunk codes
syn keyword r7rsCEFeatureId chibi chicken gambit gauche gerbil kawa larceny sagittarius contained
syn region r7rsCEFeatureLib matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*library/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsCEAux,r7rsLibName
syn region r7rsCEFeatureAON matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*\%(and\|or\|not\)/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsCESyn,@r7rsCEFeatures
syn keyword r7rsCEFeatureElse contained else
if b:r7rs_brackets_as_parens
  syn region r7rsCondExpand matchgroup=r7rsDelim start=/\[\ze[[:space:]\n]*cond-expand/ end=/\]/ contains=r7rsErr,@r7rsComs,r7rsCESyn,r7rsCEClause
  syn region r7rsCEClause matchgroup=r7rsDelim start=/\[/ end=/\]/ contained contains=r7rsErr,@r7rsComs,@r7rsCEFeatures,@r7rsData
  syn region r7rsCEFeatureLib matchgroup=r7rsDelim start=/\[\ze[[:space:]\n]*library/ end=/\]/ contained contains=r7rsErr,@r7rsComs,r7rsCEAux,r7rsLibName
  syn region r7rsCEFeatureAON matchgroup=r7rsDelim start=/\[\ze[[:space:]\n]*\%(and\|or\|not\)/ end=/\]/ contained contains=r7rsErr,@r7rsComs,r7rsCESyn,@r7rsCEFeatures
endif
if b:r7rs_braces_as_parens
  syn region r7rsCondExpand matchgroup=r7rsDelim start=/{\ze[[:space:]\n]*cond-expand/ end=/}/ contains=r7rsErr,@r7rsComs,r7rsCESyn,r7rsCEClause
  syn region r7rsCEClause matchgroup=r7rsDelim start=/{/ end=/}/ contained contains=r7rsErr,@r7rsComs,@r7rsCEFeatures,@r7rsData
  syn region r7rsCEFeatureLib matchgroup=r7rsDelim start=/{\ze[[:space:]\n]*library/ end=/}/ contained contains=r7rsErr,@r7rsComs,r7rsCEAux,r7rsLibName
  syn region r7rsCEFeatureAON matchgroup=r7rsDelim start=/{\ze[[:space:]\n]*\%(and\|or\|not\)/ end=/}/ contained contains=r7rsErr,@r7rsComs,r7rsCESyn,@r7rsCEFeatures
endif

" import (cf. R7RS, sec. 5.2) {{{2
syn region r7rsImport matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*import/ end=/)/ contains=r7rsErr,@r7rsComs,r7rsImportSyn,@r7rsImportSets
syn keyword r7rsImportSyn contained import
syn keyword r7rsImportAux contained only except prefix rename
syn cluster r7rsImportSets contains=r7rsLibName,r7rsImportOEP,r7rsImportR
syn region r7rsImportOEP matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*\%(only\|except\|prefix\)/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsImportAux,@r7rsImportSets,r7rsId
syn region r7rsImportR matchgroup=r7rsDelim start=/(\ze[[:space:]\n]*rename/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsImportAux,@r7rsImportSets,r7rsImportList
syn region r7rsImportList matchgroup=r7rsDelim start=/(/ end=/)/ contained contains=r7rsErr,@r7rsComs,r7rsId,r7rsImportList
  syn region r7rsImport matchgroup=r7rsDelim start=/\[\ze[[:space:]\n]*import/ end=/\]/ contains=r7rsErr,@r7rsComs,r7rsImportSyn,@r7rsImportSets
if b:r7rs_brackets_as_parens
  syn region r7rsImportOEP matchgroup=r7rsDelim start=/\[\ze[[:space:]\n]*\%(only\|except\|prefix\)/ end=/\]/ contained contains=r7rsErr,@r7rsComs,r7rsImportAux,@r7rsImportSets,r7rsId
  syn region r7rsImportR matchgroup=r7rsDelim start=/\[\ze[[:space:]\n]*rename/ end=/\]/ contained contains=r7rsErr,@r7rsComs,r7rsImportAux,@r7rsImportSets,r7rsImportList
  syn region r7rsImportList matchgroup=r7rsDelim start=/\[/ end=/\]/ contained contains=r7rsErr,@r7rsComs,r7rsId,r7rsImportList
endif
  syn region r7rsImport matchgroup=r7rsDelim start=/{\ze[[:space:]\n]*import/ end=/}/ contains=r7rsErr,@r7rsComs,r7rsImportSyn,@r7rsImportSets
if b:r7rs_braces_as_parens
  syn region r7rsImportOEP matchgroup=r7rsDelim start=/{\ze[[:space:]\n]*\%(only\|except\|prefix\)/ end=/}/ contained contains=r7rsErr,@r7rsComs,r7rsImportAux,@r7rsImportSets,r7rsId
  syn region r7rsImportR matchgroup=r7rsDelim start=/{\ze[[:space:]\n]*rename/ end=/}/ contained contains=r7rsErr,@r7rsComs,r7rsImportAux,@r7rsImportSets,r7rsImportList
  syn region r7rsImportList matchgroup=r7rsDelim start=/{/ end=/}/ contained contains=r7rsErr,@r7rsComs,r7rsId,r7rsImportList
endif

" Highlights {{{1

hi def link r7rsErr Error
hi def link r7rsDelim Delimiter
hi def link r7rsCom Comment
hi def link r7rsComNested r7rsCom
hi def link r7rsComSharp r7rsCom
hi def link r7rsComDatum r7rsCom
hi def link r7rsComTodo TODO
hi def link r7rsDirective Comment
hi def link r7rsId Normal
hi def link r7rsNum Number
hi def link r7rsUInt r7rsNum
hi def link r7rsBool Boolean
hi def link r7rsChar Character
hi def link r7rsCharM SpecialChar
hi def link r7rsStr String
hi def link r7rsEscLiteral r7rsChar
hi def link r7rsEscHex r7rsChar
hi def link r7rsEscMnemonic r7rsCharM
hi def link r7rsEscWrap r7rsCharM
hi def link r7rsQ r7rsSyn
hi def link r7rsQQ r7rsSyn
hi def link r7rsU r7rsAux
hi def link r7rsDot r7rsAux
hi def link r7rsLabel Underlined
hi def link r7rsSyn Statement
hi def link r7rsSynM PreProc
hi def link r7rsAux Special
hi def link r7rsProc Function
hi def link r7rsProcM PreProc
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

" vim: et sw=2 sts=-1 tw=150 fdm=marker

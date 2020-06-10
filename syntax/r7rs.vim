" Vim syntax file
" Language: Scheme (R7RS)
" Last Change: 2020-06-11
" Author: Mitsuhiro Nakamura <m.nacamura@gmail.com>
" URL: https://github.com/mnacamura/vim-r7rs-syntax
" License: MIT

if exists('b:current_syntax')
  finish
endif

let s:cpo = &cpo
set cpo&vim

" Options {{{1

" If (b|g):r7rs_strict is true, the following options are set to obey strict R7RS.
if r7rs#get('strict', 0)
  let s:brackets_as_parens = 0
  let s:braces_as_parens = 0
  let s:strict_identifier = 1
  let s:use_gauche = 0
else
  let s:more_parens = r7rs#get('more_parens', ']')
  let s:brackets_as_parens = match(s:more_parens, '[\[\]]') > -1
  let s:braces_as_parens = match(s:more_parens, '[{}]') > -1
  unlet s:more_parens
  let s:use_gauche = r7rs#get('use_gauche', 0)
  " Gauche permits identifiers like 1/pi, conflicting with s:strict_identifier.
  let s:strict_identifier = s:use_gauche ? 0 : r7rs#get('strict_identifier', 0)
endif

" }}}

" This may cause slow down but provide accurate syntax highlight.
syn sync fromstart

" Anything visible other than defined below are error.
syn match r7rsError /[^[:space:]\n]/

" Comments and directives {{{1
syn cluster r7rsComments contains=r7rsComment,r7rsCommentNested,r7rsCommentSharp,r7rsDirective

" Comments {{{2
syn region r7rsComment start=/#\@<!;/ end=/$/ contains=r7rsCommentTodo,@Spell
syn region r7rsCommentNested start=/#|/ end=/|#/ contains=r7rsCommentNested,r7rsCommentTodo,@Spell
" FIXME: highlight nested #;
" In `#; #; hello hello R7RS!`, the two `hello`s should be commented out but not.
syn region r7rsCommentSharp start=/#;/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contains=@r7rsComments skipwhite skipempty nextgroup=r7rsCommentDatum

" Comment out anything like literal identifier or number
syn match r7rsCommentDatum /#\?[^[:space:]\n|()";'`,\\#\[\]{}]\+/ contained
" Comment out character
syn match r7rsCommentDatum /#\\./ contained
syn match r7rsCommentDatum /#\\[^[:space:]\n|()";'`,\\#\[\]{}]\+/ contained
" Comment out enclosed identifier
syn region r7rsCommentDatum start=/|/ skip=/\\[\\|]/ end=/|/ contained
" Comment out string
syn region r7rsCommentDatum start=/"/ skip=/\\[\\"]/ end=/"/ contained
" Comment out label
syn match r7rsCommentDatum /#\d\+#/ contained
syn region r7rsCommentDatum start=/#\d\+=/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contained contains=@r7rsComments skipwhite skipempty nextgroup=r7rsCommentDatum
" Comment out parens
syn region r7rsCommentDatum start=/(/ end=/)/ contained contains=r7rsCommentDatum
syn region r7rsCommentDatum start=/\[/ end=/\]/ contained contains=r7rsCommentDatum
syn region r7rsCommentDatum start=/{/ end=/}/ contained contains=r7rsCommentDatum
" Move on when prefix before parens found
syn match r7rsCommentDatum /\(['`]\|,@\?\|#\([[:alpha:]]\d\+\)\?\ze(\)/ contained nextgroup=r7rsCommentDatum

syntax match r7rsCommentTodo /\c\(FIXME\|TODO\|NOTE\):\?/ contained

" Directives (cf. R7RS, sec. 2.1 (p. 8) last paragraph) {{{2
syn keyword r7rsDirective #!fold-case #!no-fold-case

" }}} }}}

" All data are classified into three types: unquoted, quoted, and quasiquoted.
" Once a list or vector is (quasi)quoted, its children are also (quasi)quoted.
" As the children may not be prefixed by ' or `, it is difficult to distinguish
" between them from their look. To highlight them differently, preparing three
" syntax groups is mandatory.
syn cluster r7rsData contains=@r7rsSimpleData,@r7rsCompoundData,r7rsLabel
syn cluster r7rsDataQ contains=@r7rsSimpleData,@r7rsCompoundDataQ,r7rsLabel
syn cluster r7rsDataQQ contains=@r7rsSimpleData,@r7rsCompoundDataQQ,r7rsLabel

" Simple data (cf. R7RS, sec. 7.1.2) {{{1
syn cluster r7rsSimpleData contains=r7rsIdentifier,r7rsBoolean,r7rsNumber,r7rsCharacter,r7rsString,r7rsBytevector

" Identifiers (cf. R7RS, sec. 2.1 ,p. 62, and SmallErrata, 7) {{{2

" Those enclosed by |
syn region r7rsIdentifier matchgroup=r7rsDelimiter start=/|/ skip=/\\[\\|]/ end=/|/ contains=@r7rsEscapedChars

if s:strict_identifier
  " <initial> <subsequent>*
  " where <initial> -> [:alpha:] | [!$%&*\/:<=>?^_~@]
  "       <subsequent> -> [:alnum:] | [!$%&*\/:<=>?^_~@] | [.+-]
  syn match r7rsIdentifier /[[:alpha:]!$%&*\/:<=>?^_~@][[:alnum:]!$%&*\/:<=>?^_~@.+-]*/

  " Peculiar identifier case 1 and 2
  " [+-] | [+-] <sign subsequent> <subsequent>*
  " where <sign subsequent> = <initial> | [+-]
  syn match r7rsIdentifier /[+-]\%([[:alpha:]!$%&*\/:<=>?^_~@+-][[:alnum:]!$%&*\/:<=>?^_~@.+-]*\)\?/

  " Peculiar identifier case 3 and 4
  " [+-] . <dot subsequent> <subsequent>* | . <dot subsequent> <subsequent>*
  " where <dot subsequent> -> <initial> | [.+-]
  syn match r7rsIdentifier /[+-]\?\.[[:alpha:]!$%&*\/:<=>?^_~@.+-][[:alnum:]!$%&*\/:<=>?^_~@.+-]*/
else
  " Anything except single '.' is permitted.
  syn match r7rsIdentifier /\.[^[:space:]\n|()";'`,\\#\[\]{}]\+/
  syn match r7rsIdentifier /[^.[:space:]\n|()";'`,\\#\[\]{}][^[:space:]\n|()";'`,\\#\[\]{}]*/
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
exec 'syn match r7rsNumber /' . r7rs#number#real('[01]') . '/'
exec 'syn match r7rsNumber /' . r7rs#number#real('\o') . '/'
exec 'syn match r7rsNumber /' . r7rs#number#real('\x') . '/'

" Complex number in rectangular notation {{{4
" ( #b | #[ei]#b | #b#[ei] )
" ( [+-]?[01]+(\/[01]+)? | [+-](inf|nan)\.0 )?
" [+-]
" ( [01]+(\/[01]+)? | (inf|nan)\.0 )?
" i
exec 'syn match r7rsNumber /' . r7rs#number#rect('[01]') . '/'
exec 'syn match r7rsNumber /' . r7rs#number#rect('\o') . '/'
exec 'syn match r7rsNumber /' . r7rs#number#rect('\x') . '/'

" Complex number in polar notation {{{4
" ( #b | #[ei]#b | #b#[ei] )
" ( [+-]?[01]+(\/[01]+)? | [+-](inf|nan)\.0 )
" \@
" ( [+-]?[01]+(\/[01]+)? | [+-](inf|nan)\.0 )
exec 'syn match r7rsNumber /' . r7rs#number#polar('[01]') . '/'
exec 'syn match r7rsNumber /' . r7rs#number#polar('\o') . '/'
exec 'syn match r7rsNumber /' . r7rs#number#polar('\x') . '/'

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
exec 'syn match r7rsNumber /' . r7rs#number#real('\d') . '/'

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
exec 'syn match r7rsNumber /' . r7rs#number#rect('\d') . '/'

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
exec 'syn match r7rsNumber /' . r7rs#number#polar('\d') . '/'

" Boolean {{{2
syn keyword r7rsBoolean #t #f #true #false

" Character {{{2
syn match r7rsCharacter /#\\./
syn match r7rsCharacter /#\\x\x\+/
syn match r7rsCharacter /#\\\%(alarm\|backspace\|delete\|escape\|newline\|null\|return\|space\|tab\)/

" String {{{2
syn region r7rsString matchgroup=r7rsDelimiter start=/"/ skip=/\\[\\"]/ end=/"/ contains=@r7rsEscapedChars,r7rsEscapedNewline

" Escapedaped characters (embedded in \"strings\" and |identifiers|) {{{2
syn cluster r7rsEscapedChars contains=r7rsEscapedLiteral,r7rsEscapedHex,r7rsEscapedMnemonic
syn match r7rsEscapedLiteral /\\[\\|"]/ contained
syn match r7rsEscapedHex /\\x\x\+;/ contained
syn match r7rsEscapedMnemonic /\\[abtnr]/ contained

" This can be contained in strings but identifiers
syn match r7rsEscapedNewline /\\[[:space:]]*$/ contained

" Bytevectors {{{2
syn region r7rsBytevector matchgroup=r7rsDelimiter start=/#u8(/ end=/)/ contains=r7rsError,@r7rsComments,r7rsNumber

" Compound data (cf. R7RS, sec. 7.1.2) {{{1
syn cluster r7rsCompoundData contains=r7rsList,r7rsVector,r7rsQuote,r7rsQuasiQuote
syn cluster r7rsCompoundDataQ contains=r7rsListQ,r7rsVectorQ,r7rsQuote,r7rsQuasiQuote
syn cluster r7rsCompoundDataQQ contains=r7rsListQQ,r7rsVectorQQ,r7rsQuote,r7rsQuasiQuote

" Unquoted lists and vector {{{2
syn region r7rsList matchgroup=r7rsDelimiter start=/#\@<!(/ end=/)/ contains=r7rsError,@r7rsComments,@r7rsData,@r7rsExpressions
if s:brackets_as_parens
  syn region r7rsList matchgroup=r7rsDelimiter start=/#\@<!\[/ end=/\]/ contains=r7rsError,@r7rsComments,@r7rsData,@r7rsExpressions
endif
if s:braces_as_parens
  syn region r7rsList matchgroup=r7rsDelimiter start=/#\@<!{/ end=/}/ contains=r7rsError,@r7rsComments,@r7rsData,@r7rsExpressions
endif
syn region r7rsVector matchgroup=r7rsDelimiter start=/#(/ end=/)/ contains=r7rsError,@r7rsComments,@r7rsData,@r7rsExpressions

" Apparently unquoted but quoted lists and vector {{{2
syn region r7rsListQ matchgroup=r7rsDelimiter start=/#\@<!(/ end=/)/ contained contains=r7rsError,@r7rsComments,@r7rsDataQ
if s:brackets_as_parens
  syn region r7rsListQ matchgroup=r7rsDelimiter start=/#\@<!\[/ end=/\]/ contained contains=r7rsError,@r7rsComments,@r7rsDataQ
endif
if s:braces_as_parens
  syn region r7rsListQ matchgroup=r7rsDelimiter start=/#\@<!{/ end=/}/ contained contains=r7rsError,@r7rsComments,@r7rsDataQ
endif
syn region r7rsVectorQ matchgroup=r7rsDelimiter start=/#(/ end=/)/ contained contains=r7rsError,@r7rsComments,@r7rsDataQ

" Apparently unquoted but quasiquoted lists and vector {{{2
syn region r7rsListQQ matchgroup=r7rsDelimiter start=/#\@<!(/ end=/)/ contained contains=r7rsError,@r7rsComments,@r7rsDataQQ,r7rsUnquote
if s:brackets_as_parens
  syn region r7rsListQQ matchgroup=r7rsDelimiter start=/#\@<!\[/ end=/\]/ contained contains=r7rsError,@r7rsComments,@r7rsDataQQ,r7rsUnquote
endif
if s:braces_as_parens
  syn region r7rsListQQ matchgroup=r7rsDelimiter start=/#\@<!{/ end=/}/ contained contains=r7rsError,@r7rsComments,@r7rsDataQQ,r7rsUnquote
endif
syn region r7rsVectorQQ matchgroup=r7rsDelimiter start=/#(/ end=/)/ contained contains=r7rsError,@r7rsComments,@r7rsDataQQ,r7rsUnquote

" Quoted simple data (any identifier, |identifier|, \"string\", or #-syntax other than '#(') {{{2
syn match r7rsQuote /'\ze[^[:space:]\n();'`,\\#\[\]{}]/ nextgroup=@r7rsSimpleData
syn match r7rsQuote /'\ze#[^(]/ nextgroup=@r7rsSimpleData

" Quoted lists and vector {{{2
syn match r7rsQuote /'\ze(/ nextgroup=r7rsQuoteList
syn region r7rsQuoteList matchgroup=r7rsDelimiter start=/(/ end=/)/ contained contains=r7rsError,@r7rsComments,@r7rsDataQ
if s:brackets_as_parens
  syn match r7rsQuote /'\ze\[/ nextgroup=r7rsQuoteList
  syn region r7rsQuoteList matchgroup=r7rsDelimiter start=/\[/ end=/\]/ contained contains=r7rsError,@r7rsComments,@r7rsDataQ
endif
if s:braces_as_parens
  syn match r7rsQuote /'\ze{/ nextgroup=r7rsQuoteList
  syn region r7rsQuoteList matchgroup=r7rsDelimiter start=/{/ end=/}/ contained contains=r7rsError,@r7rsComments,@r7rsDataQ
endif
syn match r7rsQuote /'\ze#(/ nextgroup=r7rsQuoteVector
syn region r7rsQuoteVector matchgroup=r7rsDelimiter start=/#(/ end=/)/ contained contains=r7rsError,@r7rsComments,@r7rsDataQ

" Quoted quotes {{{2
syn match r7rsQuote /'\ze'/ nextgroup=r7rsQuote
syn match r7rsQuote /'\ze`/ nextgroup=r7rsQuasiQuote
syn match r7rsQuote /'\ze,@\?/ nextgroup=r7rsUnquote

" Quasiquoted simple data (any identifier, |idenfitier|, \"string\", or #-syntax other than '#(') {{{2
syn match r7rsQuasiQuote /`\ze[^[:space:]\n();'`,\\#\[\]{}]/ nextgroup=@r7rsSimpleData
syn match r7rsQuasiQuote /`\ze#[^(]/ nextgroup=@r7rsSimpleData

" Quasiquoted lists and vector {{{2
syn match r7rsQuasiQuote /`\ze(/ nextgroup=r7rsQuasiQuoteList
syn region r7rsQuasiQuoteList matchgroup=r7rsDelimiter start=/(/ end=/)/ contained contains=r7rsError,@r7rsComments,@r7rsDataQQ,r7rsUnquote
if s:brackets_as_parens
  syn match r7rsQuasiQuote /`\ze\[/ nextgroup=r7rsQuasiQuoteList
  syn region r7rsQuasiQuoteList matchgroup=r7rsDelimiter start=/\[/ end=/\]/ contains=r7rsError,@r7rsComments,@r7rsDataQQ,r7rsUnquote
endif
if s:braces_as_parens
  syn match r7rsQuasiQuote /`\ze{/ nextgroup=r7rsQuasiQuoteList
  syn region r7rsQuasiQuoteList matchgroup=r7rsDelimiter start=/{/ end=/}/ contains=r7rsError,@r7rsComments,@r7rsDataQQ,r7rsUnquote
endif
syn match r7rsQuasiQuote /`\ze#(/ nextgroup=r7rsQuasiQuoteVector
syn region r7rsQuasiQuoteVector matchgroup=r7rsDelimiter start=/#(/ end=/)/ contained contains=r7rsError,@r7rsComments,@r7rsDataQQ,r7rsUnquote

" Quasiquoted (un)quotes {{{2
syn match r7rsQuasiQuote /`\ze'/ nextgroup=r7rsQuote
syn match r7rsQuasiQuote /`\ze`/ nextgroup=r7rsQuasiQuote
syn match r7rsQuasiQuote /`\ze,@\?/ nextgroup=r7rsUnquote

" Unquote {{{2
" It allows comments before reaching any datum.
syn region r7rsUnquote start=/,@\?/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contained contains=@r7rsComments skipwhite skipempty nextgroup=@r7rsData,@r7rsExpressions

" Dot '.' {{{2
syn keyword r7rsDot . contained containedin=r7rsList,r7rsListQ,r7rsListQQ,r7rsQuoteList,r7rsQuasiQuoteList

" Labels (cf. R7RS, sec. 2.4) {{{1
syn match r7rsLabel /#\d\+#/
syn region r7rsLabel start=/#\d\+=/ end=/\ze\%([^;#[:space:]]\|#[^|;!]\)/ contains=@r7rsComments skipwhite skipempty nextgroup=@r7rsData

" Expressions (cf. R7RS, sec. 4) {{{1
syn cluster r7rsExpressions contains=r7rsSyntax,r7rsSyntaxM,r7rsSyntaxA,r7rsFunction,r7rsFunctionM,r7rsCondExpand,r7rsImport

" Primitive expression types (cf. R7RS, sec. 4.1) {{{2
syn keyword r7rsSyntax quote lambda if
syn keyword r7rsSyntaxM set! include include-ci

" Derived expression types (cf. R7RS, sec. 4.2) {{{2

syn keyword r7rsSyntax cond case and or when unless let let* letrec letrec* let-values let*-values
syn keyword r7rsSyntax begin do parameterize guard quasiquote
syn keyword r7rsSyntaxM let-syntax letrec-syntax syntax-rules syntax-error
" NOTE: cond-expand is defined below
syn keyword r7rsSyntaxA else => unquote unquote-splicing _ ...
syn keyword r7rsFunction make-parameter

" (scheme lazy)
syn keyword r7rsSyntax delay delay-force
syn keyword r7rsFunction force promise? make-promise

" (scheme case-lambda)
syn keyword r7rsSyntax case-lambda

" Program structure (cf. R7RS, sec. 5) {{{2

syn keyword r7rsSyntaxM define define-values define-syntax define-record-type
" NOTE: import and define-library is defined below

" Standard procedures (cf. R7RS, sec. 6) {{{2

syn keyword r7rsFunction eqv? eq? equal?

syn keyword r7rsFunction number? complex? real? rational? integer? exact? inexact? exact-integer?
syn keyword r7rsFunction = < > <= >= zero? positive? negative? odd? even? max min + * - / abs floor/
syn keyword r7rsFunction floor-quotient floor-remainder truncate/ truncate-quotient truncate-remainder
syn keyword r7rsFunction quotient remainder modulo gcd lcm numerator denominator floor ceiling truncate
syn keyword r7rsFunction round rationalize square exact-integer-sqrt expt inexact exact
syn keyword r7rsFunction number->string string->number

syn keyword r7rsFunction not boolean? boolean=?

syn keyword r7rsFunction pair? cons car cdr caar cdar cadr cddr null? list? make-list list length
syn keyword r7rsFunction append reverse list-tail list-ref memq memv member assq assv assoc list-copy
syn keyword r7rsFunctionM set-car! set-cdr! list-set!

syn keyword r7rsFunction symbol? symbol=? symbol->string string->symbol

syn keyword r7rsFunction char? char=? char<? char>? char<=? char>=? char->integer integer->char

syn keyword r7rsFunction string? make-string string string-length string-ref
syn keyword r7rsFunction string=? string<? string>? string<=? string>=?
syn keyword r7rsFunction substring string-append string->list list->string string-copy
syn keyword r7rsFunctionM string-set! string-copy! string-fill!

syn keyword r7rsFunction vector? make-vector vector vector-length vector-ref vector->list list->vector
syn keyword r7rsFunction vector->string string->vector vector-copy vector-append
syn keyword r7rsFunctionM vector-set! vector-copy! vector-fill!

syn keyword r7rsFunction bytevector? make-bytevector bytevector bytevector-length bytevector-u8-ref
syn keyword r7rsFunction bytevector-copy bytevector-append utf8->string string->utf8
syn keyword r7rsFunctionM bytevector-u8-set! bytevector-copy!

syn keyword r7rsFunction procedure? apply map string-map vector-map for-each string-for-each
syn keyword r7rsFunction vector-for-each call-with-current-continuation call/cc values call-with-values
syn keyword r7rsFunction dynamic-wind

syn keyword r7rsFunction with-exception-handler raise raise-continuable error error-object?
syn keyword r7rsFunction error-object-message error-object-irritants read-error? file-error?

syn keyword r7rsFunction call-with-port input-port? output-port? textual-port? binary-port?
syn keyword r7rsFunction port? input-port-open? output-port-open? current-input-port current-output-port
syn keyword r7rsFunction current-error-port close-port close-input-port close-output-port
syn keyword r7rsFunction open-input-string open-output-string get-output-string open-input-bytevector
syn keyword r7rsFunction open-output-bytevector get-output-bytevector

syn keyword r7rsFunction read-char peek-char read-line eof-object? eof-object char-ready? read-string
syn keyword r7rsFunction read-u8 peek-u8 u8-ready? read-bytevector
syn keyword r7rsFunctionM read-bytevector!

syn keyword r7rsFunction newline write-char write-string write-u8 write-bytevector flush-output-port

syn keyword r7rsFunction features

" (scheme inexact)
syn keyword r7rsFunction finite? infinite? nan? exp log sin cos tan asin acos atan sqrt

" (scheme complex)
syn keyword r7rsFunction make-rectangular make-polar real-part imag-part magnitude angle

" (scheme cxr)
syn keyword r7rsFunction caaar cdaar cadar cddar caadr cdadr caddr cdddr
syn keyword r7rsFunction caaaar cdaaar cadaar cddaar caadar cdadar caddar cdddar
syn keyword r7rsFunction caaadr cdaadr cadadr cddadr caaddr cdaddr cadddr cddddr

" (scheme char)
syn keyword r7rsFunction char-ci=? char-ci<? char-ci>? char-ci<=? char-ci>=? char-alphabetic?
syn keyword r7rsFunction char-numeric? char-whitespace? char-upper-case? char-lower-case?
syn keyword r7rsFunction digit-value char-upcase char-downcase char-foldcase
syn keyword r7rsFunction string-ci=? string-ci<? string-ci>? string-ci<=? string-ci>=?
syn keyword r7rsFunction string-upcase string-downcase string-foldcase

" (scheme eval)
syn keyword r7rsFunction environment eval

" (scheme r5rs)
syn keyword r7rsFunction scheme-report-environment null-environment

" (scheme repl)
syn keyword r7rsFunction interaction-environment

" (scheme file)
syn keyword r7rsFunction call-with-input-file call-with-output-file with-input-from-file
syn keyword r7rsFunction with-output-to-file open-input-file open-binary-input-file open-output-file
syn keyword r7rsFunction open-binary-output-file file-exists? delete-file

" (scheme read)
syn keyword r7rsFunction read

" (scheme write)
syn keyword r7rsFunction write write-shared write-simple display

" (scheme load)
syn keyword r7rsFunctionM load

" (scheme process-context)
syn keyword r7rsFunction command-line exit emergency-exit get-environment-variable
syn keyword r7rsFunction get-environment-variables

" (scheme time)
syn keyword r7rsFunction current-second current-jiffy jiffies-per-second

" Library declaration (cf. R7RS, sec. 5.6) {{{1
syn region r7rsLibrary matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*define-library/ end=/)/ contains=r7rsError,@r7rsComments,r7rsLibrarySyntax,r7rsLibraryName,@r7rsLibraryDecls
syn keyword r7rsLibrarySyntax contained define-library export begin include include-ci include-library-declarations
syn keyword r7rsLibrarySyntaxA contained rename
syn region r7rsLibraryName matchgroup=r7rsDelimiter start=/(/ end=/)/ contained contains=r7rsError,@r7rsComments,@r7rsLibraryNameParts
syn cluster r7rsLibraryNameParts contains=r7rsIdentifier,r7rsUInt
syn match r7rsUInt /\d\+/ contained
syn cluster r7rsLibraryDecls contains=r7rsLibraryExport,r7rsImport,r7rsLibraryBegin,r7rsLibraryInclude,r7rsCondExpand
syn region r7rsLibraryExport matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*export/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsLibrarySyntax,r7rsIdentifier,r7rsLibraryExportR
syn region r7rsLibraryExportR matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*rename/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsLibrarySyntaxA,r7rsIdentifier
" This 'begin' is different from normal 'begin' (cf. R7RS, secs. 5.6.1 and 4.2.3)
syn region r7rsLibraryBegin matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*begin/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsLibrarySyntax,@r7rsData,@r7rsExpressions
syn region r7rsLibraryInclude matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*include\%(-ci\|-library-declarations\)\?/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsLibrarySyntax,r7rsString
if s:brackets_as_parens
  syn region r7rsLibrary matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*define-library/ end=/\]/ contains=r7rsError,@r7rsComments,r7rsLibrarySyntax,r7rsLibraryName,@r7rsLibraryDecls
  syn region r7rsLibraryName matchgroup=r7rsDelimiter start=/\[/ end=/\]/ contained contains=r7rsError,@r7rsComments,@r7rsLibraryNameParts
  syn region r7rsLibraryExport matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*export/ end=/\]/ contained contains=r7rsError,@r7rsComments,r7rsLibrarySyntax,r7rsIdentifier,r7rsLibraryExportR
  syn region r7rsLibraryExportR matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*rename/ end=/\]/ contained contains=r7rsError,@r7rsComments,r7rsLibrarySyntaxA,r7rsIdentifier
  syn region r7rsLibraryBegin matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*begin/ end=/\]/ contained contains=r7rsError,@r7rsComments,r7rsLibrarySyntax,@r7rsData,@r7rsExpressions
  syn region r7rsLibraryInclude matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*include\%(-ci\|-library-declarations\)\?/ end=/\]/ contained contains=r7rsError,@r7rsComments,r7rsLibrarySyntax,r7rsString
endif
if s:braces_as_parens
  syn region r7rsLibrary matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*define-library/ end=/}/ contains=r7rsError,@r7rsComments,r7rsLibrarySyntax,r7rsLibraryName,@r7rsLibraryDecls
  syn region r7rsLibraryName matchgroup=r7rsDelimiter start=/{/ end=/}/ contained contains=r7rsError,@r7rsComments,@r7rsLibraryNameParts
  syn region r7rsLibraryExport matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*export/ end=/}/ contained contains=r7rsError,@r7rsComments,r7rsLibrarySyntax,r7rsIdentifier,r7rsLibraryExportR
  syn region r7rsLibraryExportR matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*rename/ end=/}/ contained contains=r7rsError,@r7rsComments,r7rsLibrarySyntaxA,r7rsIdentifier
  syn region r7rsLibraryBegin matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*begin/ end=/}/ contained contains=r7rsError,@r7rsComments,r7rsLibrarySyntax,@r7rsData,@r7rsExpressions
  syn region r7rsLibraryInclude matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*include\%(-ci\|-library-declarations\)\?/ end=/}/ contained contains=r7rsError,@r7rsComments,r7rsLibrarySyntax,r7rsString
endif

" cond-expand (cf. R7RS, p. 15) {{{1
syn region r7rsCondExpand matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*cond-expand/ end=/)/ contains=r7rsError,@r7rsComments,r7rsCESyntax,r7rsCEClause
syn keyword r7rsCESyntax contained cond-expand and or not
syn keyword r7rsCESyntaxA contained library
syn region r7rsCEClause matchgroup=r7rsDelimiter start=/(/ end=/)/ contained contains=r7rsError,@r7rsComments,@r7rsCEFeatures,@r7rsData,@r7rsExpressions
syn cluster r7rsCEFeatures contains=r7rsCEFeatureId,r7rsCEFeatureLib,r7rsCEFeatureAON,r7rsCEFeatureElse
syn keyword r7rsCEFeatureId r7rs exact-closed exact-complex ieee-float full-unicode ratios contained
syn keyword r7rsCEFeatureId posix windows dos unix darwin gnu-linux bsd freebsd solaris contained
syn keyword r7rsCEFeatureId i386 x86-64 ppc sparc jvm clr llvm contained
syn keyword r7rsCEFeatureId ilp32 lp64 ilp64 contained
syn keyword r7rsCEFeatureId big-endian little-endian contained
syn keyword r7rsCEFeatureId debug contained
" Scheme implementations found in schemepunk codes
syn keyword r7rsCEFeatureId chibi chicken gambit gauche gerbil kawa larceny sagittarius contained
syn region r7rsCEFeatureLib matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*library/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsCESyntaxA,r7rsLibraryName
syn region r7rsCEFeatureAON matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*\%(and\|or\|not\)/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsCESyntax,@r7rsCEFeatures
syn keyword r7rsCEFeatureElse contained else
if s:brackets_as_parens
  syn region r7rsCondExpand matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*cond-expand/ end=/\]/ contains=r7rsError,@r7rsComments,r7rsCESyntax,r7rsCEClause
  syn region r7rsCEClause matchgroup=r7rsDelimiter start=/\[/ end=/\]/ contained contains=r7rsError,@r7rsComments,@r7rsCEFeatures,@r7rsData,@r7rsExpressions
  syn region r7rsCEFeatureLib matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*library/ end=/\]/ contained contains=r7rsError,@r7rsComments,r7rsCESyntaxA,r7rsLibraryName
  syn region r7rsCEFeatureAON matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*\%(and\|or\|not\)/ end=/\]/ contained contains=r7rsError,@r7rsComments,r7rsCESyntax,@r7rsCEFeatures
endif
if s:braces_as_parens
  syn region r7rsCondExpand matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*cond-expand/ end=/}/ contains=r7rsError,@r7rsComments,r7rsCESyntax,r7rsCEClause
  syn region r7rsCEClause matchgroup=r7rsDelimiter start=/{/ end=/}/ contained contains=r7rsError,@r7rsComments,@r7rsCEFeatures,@r7rsData,@r7rsExpressions
  syn region r7rsCEFeatureLib matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*library/ end=/}/ contained contains=r7rsError,@r7rsComments,r7rsCESyntaxA,r7rsLibraryName
  syn region r7rsCEFeatureAON matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*\%(and\|or\|not\)/ end=/}/ contained contains=r7rsError,@r7rsComments,r7rsCESyntax,@r7rsCEFeatures
endif

" import (cf. R7RS, sec. 5.2) {{{1
syn region r7rsImport matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*import/ end=/)/ contains=r7rsError,@r7rsComments,r7rsImportSyntax,@r7rsImportSets
syn keyword r7rsImportSyntax contained import
syn keyword r7rsImportSyntaxA contained only except prefix rename
syn cluster r7rsImportSets contains=r7rsLibraryName,r7rsImportOEP,r7rsImportR
syn region r7rsImportOEP matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*\%(only\|except\|prefix\)/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsImportSyntaxA,@r7rsImportSets,r7rsIdentifier
syn region r7rsImportR matchgroup=r7rsDelimiter start=/(\ze[[:space:]\n]*rename/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsImportSyntaxA,@r7rsImportSets,r7rsImportList
syn region r7rsImportList matchgroup=r7rsDelimiter start=/(/ end=/)/ contained contains=r7rsError,@r7rsComments,r7rsIdentifier,r7rsImportList
if s:brackets_as_parens
  syn region r7rsImport matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*import/ end=/\]/ contains=r7rsError,@r7rsComments,r7rsImportSyntax,@r7rsImportSets
  syn region r7rsImportOEP matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*\%(only\|except\|prefix\)/ end=/\]/ contained contains=r7rsError,@r7rsComments,r7rsImportSyntaxA,@r7rsImportSets,r7rsIdentifier
  syn region r7rsImportR matchgroup=r7rsDelimiter start=/\[\ze[[:space:]\n]*rename/ end=/\]/ contained contains=r7rsError,@r7rsComments,r7rsImportSyntaxA,@r7rsImportSets,r7rsImportList
  syn region r7rsImportList matchgroup=r7rsDelimiter start=/\[/ end=/\]/ contained contains=r7rsError,@r7rsComments,r7rsIdentifier,r7rsImportList
endif
if s:braces_as_parens
  syn region r7rsImport matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*import/ end=/}/ contains=r7rsError,@r7rsComments,r7rsImportSyntax,@r7rsImportSets
  syn region r7rsImportOEP matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*\%(only\|except\|prefix\)/ end=/}/ contained contains=r7rsError,@r7rsComments,r7rsImportSyntaxA,@r7rsImportSets,r7rsIdentifier
  syn region r7rsImportR matchgroup=r7rsDelimiter start=/{\ze[[:space:]\n]*rename/ end=/}/ contained contains=r7rsError,@r7rsComments,r7rsImportSyntaxA,@r7rsImportSets,r7rsImportList
  syn region r7rsImportList matchgroup=r7rsDelimiter start=/{/ end=/}/ contained contains=r7rsError,@r7rsComments,r7rsIdentifier,r7rsImportList
endif

" Highlights {{{1

hi def link r7rsError Error
hi def link r7rsDelimiter Delimiter
hi def link r7rsComment Comment
hi def link r7rsCommentNested r7rsComment
hi def link r7rsCommentSharp r7rsComment
hi def link r7rsCommentDatum r7rsComment
hi def link r7rsCommentTodo TODO
hi def link r7rsDirective Comment
hi def link r7rsIdentifier Normal
hi def link r7rsNumber Number
hi def link r7rsUInt r7rsNumber
hi def link r7rsBoolean Boolean
hi def link r7rsCharacter Character
hi def link r7rsSpecialChar SpecialChar
hi def link r7rsString String
hi def link r7rsEscapedLiteral r7rsCharacter
hi def link r7rsEscapedHex r7rsCharacter
hi def link r7rsEscapedMnemonic r7rsSpecialChar
hi def link r7rsEscapedNewline r7rsSpecialChar
hi def link r7rsQuote r7rsSyntax
hi def link r7rsQuasiQuote r7rsSyntax
hi def link r7rsUnquote r7rsSyntaxA
hi def link r7rsDot r7rsSyntaxA
hi def link r7rsLabel Underlined
hi def link r7rsSyntax Statement
hi def link r7rsSyntaxM PreProc
hi def link r7rsSyntaxA Special
hi def link r7rsFunction Function
hi def link r7rsFunctionM PreProc
hi def link r7rsLibrarySyntax r7rsSyntaxM
hi def link r7rsLibrarySyntaxA r7rsSyntaxA
hi def link r7rsCESyntax r7rsLibrarySyntax
hi def link r7rsCESyntaxA r7rsLibrarySyntaxA
hi def link r7rsCEFeatureId Tag
hi def link r7rsCEFeatureElse r7rsCESyntaxA
hi def link r7rsImportSyntax r7rsLibrarySyntax
hi def link r7rsImportSyntaxA r7rsLibrarySyntaxA

" }}}

let b:current_syntax = 'r7rs'

let b:did_r7rs_syntax = 1
runtime! syntax/r7rs-large.vim
if s:use_gauche
  runtime! syntax/gauche.vim
endif
unlet b:did_r7rs_syntax

let &cpo = s:cpo
unlet s:cpo

" vim: et sw=2 sts=-1 tw=100 fdm=marker

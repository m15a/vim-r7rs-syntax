# vim-gauche-syntax

Syntax highlight for Gauche and R7RS Scheme.

## Status

Currently under heavy development.

## Installation

Follow usual vim plugin installation procedure.

## Options

For all options below, if both global and buffer local ones are found, the
buffer local one takes precedence.

### r7rs_strict

The following lets syntax highlight strictly obey the Scheme language
specification in the R7RS report: it restricts use of `[]` and `{}` as
parentheses (see [`g:r7rs_more_parens`](#r7rs_more_parens)) and rejects some
identifiers that could be accepted in the wild (see
[`g:r7rs_strict_identifier`](#r7rs_strict_identifier)).
```vim
    let g:r7rs_strict = 1  " default: 0
    let b:r7rs_strict = 1  " default: 0
```
Turning it on is identical to setting
```vim
    let _:r7rs_more_parens = ''
    let _:r7rs_strict_identifier = 1
```
where `_` reads either `g` or `b` henceforth.

Note: If `g:r7rs_strict` or `b:r7rs_strict` is set, the other relevant options
are ignored even if they are set.

### r7rs_more_parens

If square brackets `[]` and curly braces `{}` are included in this option,
they are accepted as additional parentheses by syntax highlight.
```vim
    let _:r7rs_more_parens = ']}'  " default: ']'
```
It does not care about whether opening `[{` or closing `]}`.

### r7rs_strict_identifier

If this option is turned off, any identifier other than single `.` are
accepted by syntax highlight. If turned on, only those specified in the R7RS
report are accepted.
```vim
    let _:r7rs_strict_identifier = 1  " default: 0
```
If this option is turned on, for example, identifiers starting from digits or
containing non-ascii letters are rejected. For more details, see
[the R7RS report][1], sec. 7.1.1 (p. 62) and [the errata][2], 7.

[1]: https://small.r7rs.org/
[2]: https://small.r7rs.org/wiki/R7RSSmallErrata/

## License

[MIT](LICENSE)

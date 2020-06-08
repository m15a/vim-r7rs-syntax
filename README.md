# vim-r7rs-syntax

Yet another syntax highlight for R7RS Scheme and Gauche.

## Development status

- [x] R7RS-small 
- [ ] R7RS-large
    - [x] `(scheme list)`
    - [x] `(scheme vector @)`
- [ ] SRFI
- [ ] Gauche (mostly implemented. See [TODO](TODO.md))

## Installation

Follow usual vim plugin installation procedure.

## Options

For all options below, if both global and buffer local ones are found, the
buffer local one takes precedence.  In the example codes, only global options
`g:...` are shown but `b:...` also works.

### r7rs_strict

This option forces syntax highlight to obey the Scheme language specification
in R7RS: it restricts use of `[]` and `{}` as parentheses (see
[`g:r7rs_more_parens`](#r7rs_more_parens)) and rejects some identifiers that
could be accepted in the wild (see
[`g:r7rs_strict_identifier`](#r7rs_strict_identifier)).
```vim
    let g:r7rs_strict = 1  " default: 0
```
Enabling this option is equivalent to setting
```vim
    let g:r7rs_more_parens = ''
    let g:r7rs_strict_identifier = 1
```

NOTE: If `g:r7rs_strict` is set, the other relevant options are ignored.

### r7rs_more_parens

If square brackets `[]` and curly braces `{}` are included in this option,
they are accepted as additional parentheses.
```vim
    let g:r7rs_more_parens = ']}'  " default: ']'
```
It does not care about whether the parens are opening `[{` or closing `]}`.

### r7rs_strict_identifier

If this option is disabled (default), any identifier other than single `.` are
accepted.  If enabled, only those specified in R7RS are accepted: identifiers
starting from digits, containing non-ascii letters, etc. are rejected.
```vim
    let g:r7rs_strict_identifier = 1  " default: 0
```
For more details, see [R7RS][1], sec. 7.1.1 (p. 62) and [the errata][2], 7.

### r7rs_use_gauche

This option enables highlight for Gauche's extended reader syntax (e.g.,
`#/`), numeric literal (e.g., `#e123_456@789pi`), extra functions, objects
(`<class>`), etc.
```vim
    let g:r7rs_use_gauche = 1  " default: 0
```
Enjoy Gauche!

[1]: https://small.r7rs.org/
[2]: https://small.r7rs.org/wiki/R7RSSmallErrata/

## License

[MIT](LICENSE)

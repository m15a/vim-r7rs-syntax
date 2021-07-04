# vim-r7rs-syntax

Vim syntax highlighting for [R7RS Scheme][1] and [Gauche][3].

![Screenshot](./preview.png)
(with `g:r7rs_use_gauche = 1`)

## Development status

- [x] R7RS-small 
- [x] R7RS-large: [Red][7] and [Tangerine][8] editions
- [ ] SRFI: See [SRFIs tracking issue][6].
- [ ] Gauche: Mostly implemented. See [TODO](TODO.md).

## Installation

Use your favorite package manager. For example using [Paq][4]:

```lua
require'paq-nvim' {
  'mnacamura/vim-r7rs-syntax',
}
```

## Options

For all options, if both global and buffer local ones are defined, the
buffer local one takes precedence.

### `r7rs_strict`

This option forces syntax highlighting to obey the Scheme language
specification in R7RS: it restricts use of `[]` and `{}` as parentheses (see
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
let g:r7rs_use_gauche = 0
```

If `g:r7rs_strict` is set, the other relevant options are ignored.

### `r7rs_more_parens`

If square brackets `[]` and curly braces `{}` are included in this option,
they are accepted as additional parentheses.

```vim
let g:r7rs_more_parens = ']}'  " default: ']'
```

It does not care about whether the parens are opening `[{` or closing `]}`.

### `r7rs_strict_identifier`

If this option is disabled (default), any identifier other than single `.` are
accepted.  If enabled, only those specified in R7RS are accepted: identifiers
starting from digits, containing non-ASCII letters, etc. are rejected.

```vim
let g:r7rs_strict_identifier = 1  " default: 0
```

For more details, see [R7RS][1], sec. 7.1.1 (p. 62) and [the errata][2], 7.

### `r7rs_use_gauche`

This option enables highlighting for Gauche's extended reader syntaxes
(`#/regexp/`, `#[charset]`, `#"~(interpolated) string"`, ...), numeric
literals (`#12r34_56@78pi`), `:keywords`, `<objects>`, and a bunch of extra
syntaxes/procedures.

```vim
let g:r7rs_use_gauche = 1  " default: 0
```

Enjoy Gauche!

If `g:use_gauche` is set, `g:strict_identifier` is ignored since identifiers
in Gauche are not strict (e.g., `1/pi` in `math.const` module).

## Change log

### Unreleased

* Add missing keywords for Gauche 0.9.10
* Support the following SRFIs:
  - SRFI 17
  - SRFI 18
  - SRFI 21
  - SRFI 25
  - SRFI 26
  - SRFI 27
  - SRFI 152

### [0.2.1][v0.2.1] (2021-06-28)

* Fix highlighting for `r7rsVariable`
* Fix highlighting for `@vector-comparator`

### [0.2][v0.2] (2021-06-27)

* Fix Gauche shebang to accept `<file-start>#!<newline>`
* Support all R7RS-large libraries in Red and Tangerine editions
* Support the following SRFIs:
  - SRFI 2
  - SRFI 8
  - SRFI 22
  - SRFI 112
  - SRFI 118
  - SRFI 120
  - SRFI 129
  - SRFI 145

### [0.1][v0.1] (2021-06-22)

* Support R7RS small
* Support R7RS-large libraries except:
  - `(scheme ilist)`
  - `(scheme rlist)`
  - `(scheme text)`
  - `(scheme bytevector)`
  - `(scheme show)`
* Support Gauche 0.9.10 except SRFIs 7 and 10

## License

[MIT](LICENSE)

[1]: https://small.r7rs.org/
[2]: https://small.r7rs.org/wiki/R7RSSmallErrata/
[3]: https://practical-scheme.net/gauche/
[4]: https://github.com/savq/paq-nvim/
[6]: https://github.com/mnacamura/vim-r7rs-syntax/issues/7
[7]: https://github.com/johnwcowan/r7rs-work/blob/master/RedEdition.md
[8]: https://github.com/johnwcowan/r7rs-work/blob/master/TangerineEdition.md
[v0.1]: https://github.com/mnacamura/vim-r7rs-syntax/tree/v0.1
[v0.2]: https://github.com/mnacamura/vim-r7rs-syntax/tree/v0.2
[v0.2.1]: https://github.com/mnacamura/vim-r7rs-syntax/tree/v0.2.1

<!-- vim: set tw=78 spell: -->

# TODO

## SRFI
- [ ] SRFI-7
    - [ ] `{configuration language}`
    - [ ] `{program clause}`
- [ ] SRFI-10 (`#,`)

## Gauche

- [x] Add sharp-syntaxes
    - [x] `#!`
    - [x] `#"`
    - [x] `#(`
    - [x] `#*`
    - [x] `#/`
    - [x] `#0`...`#9`
    - [x] `#:` it's ok to colorize this as ordinal symbol
    - [x] `#;`
    - ~~`#<`~~ unreadable object, no need
    - [x] `#?`
    - [x] `#b`, `#d`, `#o`, `#x`, `#e`, `#i`
    - [x] `#t`, `#f`
    - [x] `#u`, `#s`, `#f`, `#c`
    - [x] `#[`
    - [x] `#\`
    - [x] `#|`
- [x] Highlight `use` like `import`
- [x] Highlight keywords (`:key` ~~and `#:key`~~)
- [x] Add numeric literals (including `#\d[rR]...`)
- [ ] Highlight `format` keywords?
- [ ] Build syntax file from texinfo tags
    - [x] `@defmacx?`
    - [x] `@defspecx?`
    - [x] `@defunx?`
    - [x] `@deffnx?`
        - [x] `{cise expression}`
        - [x] `{cise statement}`
        - [x] `{cise type}`
        - [x] `{ec qualifier}`
        - [x] `{function}`
        - [x] `{generic function}`
        - ~~`{generic application}`~~ no need
        - [x] `{method}`
        - [x] `{next method}`
        - [x] `{parameter}`
        - [x] `{stub form}`
    - [x] `@defvarx?`
    - [x] `@defvrx?`
        - [x] `{comparator}`
        - [x] `{constant}`
    - [x] `@deftpx?`
        - [x] `{builtin class}` regex match
        - [x] `{builtin module}`
        - [x] `{class}` regex match
        - [x] `{condition type}` regex match
        - ~~`{environment variable}`~~ no need
        - [x] `{function}`
        - [x] `{metaclass}` regex match
        - [x] `{module}`
        - [x] `{parameter}`
        - ~~`{reader syntax}`~~ no need
        - ~~`{record type}`~~ `job` in `control.job` only, omit it
        - ~~`{record}`~~ ditto
    - [ ] `{subprocess argument}` DSL in `gauche.process`. `:redirects` have operators like `<`,
          `>>`, and `>&`. Highlight them specially?
    - ~~`@defivarx?`~~ instance variables
    - ~~`@defcodeindex`~~ generating texinfo index, can be skipped
- [x] Add `lispword`s
    - `@def(spec|mac)x?` of form `(syntax-name at-least-one-arg ... body-ish ...)`

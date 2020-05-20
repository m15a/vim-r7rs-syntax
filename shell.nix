with import <nixpkgs> {};

let
  gauche_src = runCommand "${gauche.name}-src" {
    inherit (gauche) src;
  } ''
    tar xf "$src"
    mkdir -p "$out"/doc
    cp -r */doc/*.texi "$out"/doc
  '';
in

mkShell {
  buildInputs = [ gauche shellcheck ];

  GAUCHE_SRC = gauche_src;

  VIM_SRC = vim.src;

  shellHook = ''
  '';
}

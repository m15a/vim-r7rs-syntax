with import <nixpkgs> {};

let
  gauche_doc = runCommand "${gauche.name}-doc" {
    inherit (gauche) src;
  } ''
    tar xf "$src"
    mkdir -p "$out"
    cp -r */doc/*.texi "$out"/
  '';
in

mkShell {
  buildInputs = [ shellcheck ];

  GAUCHE_DOC = gauche_doc;

  VIM_RUNTIME = "${vim.src}/runtime";

  shellHook = ''
  '';
}

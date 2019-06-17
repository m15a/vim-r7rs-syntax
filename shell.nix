with import <nixpkgs> {};

let
  gauche_src = stdenvNoCC.mkDerivation {
    name = "${gauche.name}-src";
    inherit (gauche) src;
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p $out
      cp -R * $out/
    '';
  };
  vim_runtime = stdenvNoCC.mkDerivation {
    name = "${vim.name}-runtime";
    inherit (vim) src;
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p $out
      cp -R runtime/* $out/
    '';
  };
in

mkShell {
  buildInputs = [ gauche ];

  GAUCHE_SRC = gauche_src;
  VIM_RUNTIME = vim_runtime;

  shellHook = ''
  '';
}

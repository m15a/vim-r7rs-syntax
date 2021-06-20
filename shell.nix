let
  pkgs = import (fetchNixpkgs {
    rev = "a2c3ea5bf825348322c901358b155f651d8ed699";
    sha256 = "0rxn9wg73gvgb7zwzrdhranlj3jpkkcnsqmrzw5m0znwv6apj6k4";
  }) {};

  fetchNixpkgs = { rev, sha256 }:
  builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256;
  };
in

with pkgs;

mkShell {
  buildInputs = [ gauche shellcheck vim-vint ];

  GAUCHE_SRC = gauche.src;

  VIM_SRC = vim.src;

  GAUCHE_READ_EDIT = "yes";

  shellHook = ''
  '';
}

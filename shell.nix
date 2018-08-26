{ pkgs ? import <nixpkgs> {} }:
let
  pkgs_src = pkgs.fetchgit {
    url = "https://github.com/domenkozar/nixpkgs";
    rev = "6046600dfabf5b97ba077b9f345c6917c9ef80ad";
    sha256 = "1rwc9iic6xwm9qbkr84njwcziy6dr3vg64nklpnq4fkfadb69gw4";
    fetchSubmodules = true;
  };

  pkgs_ = import "${pkgs_src}" {};
in
with pkgs;
with stdenv;
mkDerivation {
  name = "elm-mdc";
  buildInputs = [
    pkgs_.elmPackages.elm
    nodejs-9_x
  ];
}

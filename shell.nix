{ pkgs ? import <nixpkgs> {} }:
let
  nixpkgs-unstable = import /home/aforemny/src/nixpkgs/default.nix {};
in
with pkgs;
with stdenv;
mkDerivation {
  name = "elm-mdc";
  buildInputs = [
    # Elm 0.19 is available in the nixpkgs-unstable channel for now
    nixpkgs-unstable.elmPackages.elm
    nixpkgs-unstable.elmPackages.elm-format
    nodejs-9_x
  ];
}

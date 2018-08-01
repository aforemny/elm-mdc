{ pkgs ? import <nixpkgs> {} }:
with pkgs;
with stdenv;
mkDerivation {
  name = "elm-mdc";
  buildInputs = [
    elmPackages.elm-make
    elmPackages.elm-repl
    elmPackages.elm-package
    elmPackages.elm-reactor
    nodejs-9_x
  ];
}

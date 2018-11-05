{ pkgs ? import <nixpkgs> {} }:
with pkgs;
with stdenv;
mkDerivation {
  name = "elm-mdc";
  buildInputs = [ elmPackages.elm elmPackages.elm-format nodejs-10_x ];
}

{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    gh-issues-to-rss = callPackage ./packages/gh-issues-to-rss {};
    fluent-theme = callPackage ./packages/fluent-theme {};
  };
in
self

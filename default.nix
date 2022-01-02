{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    gh-issues-to-rss = callPackage ./packages/gh-issues-to-rss {};
    fluent-theme = callPackage ./packages/fluent-theme {};
    kmonad = callPackage ./packages/kmonad {};
    traffic = callPackage ./packages/traffic {};
    notmuch-git = callPackage ./packages/notmuch-git {};
    gnomeExtensions.steal-my-focus = callPackage ./packages/steal-my-focus {};

    buf = callPackage ./packages/buf {};
  };
in
self

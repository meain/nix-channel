{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    ## personal
    traffic = callPackage ./packages/traffic {};
    gh-issues-to-rss = callPackage ./packages/gh-issues-to-rss {};
    tojson = callPackage ./packages/tojson {};
    toffee = callPackage ./packages/toffee {};
    quickserve = callPackage ./packages/quickserve {};

    ## external
    fluent-theme = callPackage ./packages/fluent-theme {};
    kmonad = callPackage ./packages/kmonad {};
    # notmuch-git = callPackage ./packages/notmuch-git {};
    gnomeExtensions.steal-my-focus = callPackage ./packages/steal-my-focus {};
    grpc-gateway = callPackage ./packages/grpc-gateway {};

    ## programming
    # buf = callPackage ./packages/buf {};
  };
in
self

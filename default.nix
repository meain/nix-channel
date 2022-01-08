{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {
    ## personal
    traffic = callPackage ./packages/traffic { };
    gh-issues-to-rss = callPackage ./packages/gh-issues-to-rss { };
    tojson = callPackage ./packages/tojson { };
    toffee = callPackage ./packages/toffee { };
    quickserve = callPackage ./packages/quickserve { };

    ## external
    fluent-theme = callPackage ./packages/fluent-theme { };
    kmonad = callPackage ./packages/kmonad { };
    # notmuch-git = callPackage ./packages/notmuch-git {};
    gnomeExtensions.steal-my-focus = callPackage ./packages/steal-my-focus { };
    grpc-gateway = callPackage ./packages/grpc-gateway { };
    # golang-migrate::tags: postgres mysql redshift cassandra spanner cockroachdb clickhouse file go_bindata github aws_s3 google_cloud_storage godoc_vfs gitlab
    golang-migrate = callPackage ./packages/golang-migrate { tags = "postgres file"; }; # with proper build tags

    ## programming
    # buf = callPackage ./packages/buf {};
  };
in
self

{ fetchurl, fetchgit, lib, stdenv
, pkg-config, gnupg
, xapian, gmime, talloc, zlib
, doxygen, perl, texinfo, gmime3
, pythonPackages
, emacs
, ruby
, which, dtach, openssl, bash, gdb, man
, withEmacs ? true
}:

with lib;

stdenv.mkDerivation rec {
  version = "0.34";
  pname = "notmuch";

  passthru = {
    pythonSourceRoot = "${src.name}/bindings/python";
    inherit version;
  };

  src = fetchgit {
    url = "https://git.notmuchmail.org/git/notmuch";
    sha256 = "sha256:08k7slmq894fiwkfc5bfqjckfdj8lb1b07cmmz6g5yr87yyjkmll";
    rev = version;
  };

  nativeBuildInputs = [
    pkg-config
    doxygen                   # (optional) api docs
    pythonPackages.sphinx     # (optional) documentation -> doc/INSTALL
    texinfo                   # (optional) documentation -> doc/INSTALL
  ] ++ optional withEmacs [ emacs ];

  buildInputs = [
    gnupg                     # undefined dependencies
    xapian gmime talloc zlib  # dependencies described in INSTALL
    perl
    pythonPackages.python
    ruby
    gmime3
  ];

  postPatch = ''
    patchShebangs configure
    patchShebangs test/
    substituteInPlace lib/Makefile.local \
      --replace '-install_name $(libdir)' "-install_name $out/lib"
  '' + optionalString withEmacs ''
    substituteInPlace emacs/notmuch-emacs-mua \
      --replace 'EMACS:-emacs' 'EMACS:-${emacs}/bin/emacs' \
      --replace 'EMACSCLIENT:-emacsclient' 'EMACSCLIENT:-${emacs}/bin/emacsclient'
  '';

  configureFlags = [
    "--zshcompletiondir=${placeholder "out"}/share/zsh/site-functions"
    "--bashcompletiondir=${placeholder "out"}/share/bash-completion/completions"
    "--infodir=${placeholder "info"}/share/info"
  ] ++ optional (!withEmacs) "--without-emacs"
    ++ optional (withEmacs) "--emacslispdir=${placeholder "emacs"}/share/emacs/site-lisp"
    ++ optional (isNull ruby) "--without-ruby";

  # Notmuch doesn't use autoconf and consequently doesn't tag --bindir and
  # friends
  setOutputFlags = false;
  enableParallelBuilding = true;
  makeFlags = [ "V=1" ];


  outputs = [ "out" "man" "info" ] ++ lib.optional withEmacs "emacs";

  preCheck = let
    test-database = fetchurl {
      url = "https://notmuchmail.org/releases/test-databases/database-v1.tar.xz";
      sha256 = "1lk91s00y4qy4pjh8638b5lfkgwyl282g1m27srsf7qfn58y16a2";
    };
  in ''
    mkdir -p test/test-databases
    ln -s ${test-database} test/test-databases/database-v1.tar.xz
  '';
  doCheck = !stdenv.hostPlatform.isDarwin && (versionAtLeast gmime.version "3.0.3");
  checkTarget = "test";
  checkInputs = [
    which dtach openssl bash
    gdb man emacs
  ];

  # Expects there to always be a thread with ID
  # thread:0000000000000009, but notmuch new is non-deterministic so
  # this isn't always the case.  Upstream bug report:
  # https://nmbug.notmuchmail.org/nmweb/show/871reno6g7.fsf%40alyssa.is
  NOTMUCH_SKIP_TESTS = "lib-thread";

  installTargets = [ "install" "install-man" "install-info" ];

  postInstall = lib.optionalString withEmacs ''
    moveToOutput bin/notmuch-emacs-mua $emacs
  '';

  dontGzipMan = true; # already compressed

  meta = {
    description = "Mail indexer";
    homepage    = "https://notmuchmail.org/";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ flokli puckipedia ];
    platforms   = platforms.unix;
  };
}

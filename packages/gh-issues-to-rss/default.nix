{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gh-issues-to-rss";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "meain";
    repo = "gh-issues-to-rss";
    rev = "${version}";
    sha256 = "sha256-cZKCwPIyAVwNeNC+uSThqupRq2bFSg0ZVqRhQa8/UOY=";
  };

  vendorSha256 = "sha256-XWdPyHJF/LGTjUllqbPPn+B/19XgoMP9Au6/fnl/YXg=";

  runVend = true;

  meta = with lib; {
    description = "Convert Github issues and PRs into an rss feed";
    license = lib.licenses.asl20;
    homepage = "https://github.com/meain/gh-issues-to-rss";
    platforms = platforms.linux ++ platforms.darwin;
  };
}

{ stdenv, fetchgit, perl, buildLinux, ncurses, openssh, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.14.0";
  extraMeta.branch = "3.14";

  src = fetchgit {
    url = "git://abbradar.net/linux";
    rev = "f7c35184632c40ee6f8e6515bc27cac815dc0363";
    sha256 = "d9d4f78ac0cc966cbfd10a7a2a0af5587bcfafc73676714a3b441b706115fecb";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
  features.chromiumos = true;
} // (args.argsOverride or {}))

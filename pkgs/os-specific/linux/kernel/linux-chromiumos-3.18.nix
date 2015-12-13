{ stdenv, fetchgit, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/third_party/kernel";

    # rev = "c2483e86e282461afb4b738f0bbb10af9a86b3aa";
    # sha256 = "0kk0yysfcp2x5a3x6jkw1ap42lvlfbhvhx5mkp11i35zwk61pb7g";

    rev = "3179ec7e3f07fcc3ca35817174c5fc6584030ab3";
    sha256 = "0hfa97fs216x8q20fsmw02kvf6mw6c6zczfjk2bpym6v7zxdzj28";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
  features.chromiumos = true;
} // (args.argsOverride or {}))

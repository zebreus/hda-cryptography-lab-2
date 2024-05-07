{
  description = "Report for the first lab of the cryptography course at h_da";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:zebreus/nixpkgs?ref=f1a3be7a1160cc4810c0274ab76f0fac813eb4d6";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      rec {
        pkgs = import nixpkgs { inherit system; };

        name = "hda-cryptography-lab1";
        packages.default = import ./default.nix { pkgs = pkgs; };
      }
    );
}

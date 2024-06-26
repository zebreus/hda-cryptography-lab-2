{
  description = "Report for the first lab of the cryptography course at h_da";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:zebreus/nixpkgs?ref=f1a3be7a1160cc4810c0274ab76f0fac813eb4d6";
    unstable_nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, unstable_nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      rec {
        unstable-pkgs = import unstable_nixpkgs { inherit system; };
        pkgs = import nixpkgs
          {
            inherit system;
            overlays = [
              (self: super: {
                llvmPackages_18 = unstable-pkgs.llvmPackages_18;
              })
            ];
          };

        name = "hda-cryptography-lab-2";
        # Use `nix run` to build the report
        packages.default = pkgs.writeShellApplication
          {
            name = "hda-cryptography-lab-2";

            runtimeInputs = with pkgs; [
              python3
              asciidoctor-web-pdf
              asciidoctor-js
              sass
              gnumake
              jq
            ];

            text = ''
              make Readme.pdf
            '';
          };
        # Use `nix develop` to enter a shell with all dependencies
        devShell = pkgs.mkShell {
          buildInputs = with pkgs;
            [
              python3
              asciidoctor-web-pdf
              asciidoctor-js
              sass
              gnumake
              nixpkgs-fmt
              nil
              jq
              llvmPackages_18.clang
              openssl
              clang-tools
            ];
        };
      }
    );
}

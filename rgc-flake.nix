{
  description = "Ranked Gaming Client (RGC) Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

        # Fetch RGC from GitHub using git fetcher for better reproducibility
        rgc = pkgs.stdenv.mkDerivation {
          name = "ranked-gaming-client";
          src = pkgs.fetchFromGitHub {
            owner = "rgc-project";
            repo = "RGC";
            rev = "master";
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with actual hash after fetching
          };

          nativeBuildInputs = [ pkgs.makeWrapper ];

          buildInputs = [ pkgs.wine pkgs.wineWowPackages.stable ];

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            cp -r RGC-master/* $out/ || true
            
            # Wrap the executable to ensure Wine is in PATH
            wrapProgram $out/bin/RGC.exe \
              --prefix PATH : ${pkgs.wine}/bin
            
            runHook postInstall
          '';

        };

      in {
        packages.rgc = rgc;
        defaultPackage = rgc;
      }
    );
}

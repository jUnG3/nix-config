{ lib, config, pkgs, ... }: {

  description = "RGC Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs' = import nixpkgs { inherit system; config.allowUnfree = true; };

        rgcSourceUrl = "https://github.com/rgc-project/RGC/archive/master.zip"; # Adjust if needed, or use a local path/sha256 hash approach for stability.
        
        rgc = pkgs.stdenv.mkDerivation {
          name = "ranked-gaming-client";
          src = pkgs.fetchurl {
            url = rgcSourceUrl;
            sha256 = "placeholder-for-actual-sha256-hash"; # You MUST calculate this or use a stable git ref.
          };

          buildInputs = [ pkgs.cmake ];

          nativeBuildInputs = [ pkgs.makeWrapper ];

          cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            cp -r RGC-master/* $out/ || true # Adjust path based on actual extraction result if using zip, or clone directly.
            
            # If it's a git clone: 
            # cp -r . $out/

            runHook postInstall
          '';

        };

      in {
        packages.rgc = rgc;
        defaultPackage = rgc;
      }
    );
}

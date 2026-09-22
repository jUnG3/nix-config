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

        # Fetch RGC from the official download URL
        rgc = pkgs.stdenv.mkDerivation {
          name = "ranked-gaming-client";
          src = pkgs.fetchurl {
            url = "https://rankedgaming.com/api/updates/download-client?v=0.1.115";
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with actual hash
          };

          nativeBuildInputs = [ pkgs.makeWrapper pkgs.unzip ];

          buildInputs = [ pkgs.wine pkgs.wineWowPackages.stable ];

          installPhase = ''
            runHook preInstall
            
            # Create Wine prefix for 64-bit installation
            export WINEPREFIX=$out/wineprefix
            mkdir -p $WINEPREFIX
            export WINEARCH=win64
            wineboot --init
            
            # Extract the installer zip
            unzip -q $src -d $out/extracted
            
            # Run the installer with Wine
            cd $out/extracted
            wine RGC-Setup.exe /S
            
            # Find and wrap the installed executable
            mkdir -p $out/bin
            cp -r $out/extracted/RGC* $out/bin/ 2>/dev/null || true
            
            # Wrap the executable to ensure Wine is in PATH
            wrapProgram $out/bin/RGC.exe \
              --prefix PATH : ${pkgs.wine}/bin \
              --prefix WINEPREFIX : $WINEPREFIX
            
            runHook postInstall
          '';

        };

      in {
        packages.x86_64-linux.rgc = rgc;
        defaultPackage.x86_64-linux = rgc;
      }
    );
}

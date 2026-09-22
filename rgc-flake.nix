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
            sha256 = "1zwjzx3l81wpyr4wjqkc6gkh67x7n90m0ms47vbwlrnx8m2h09wn";
          };

          nativeBuildInputs = [ pkgs.makeWrapper pkgs.unzip pkgs.wine ];

          buildInputs = [ pkgs.wineWowPackages.stable ];

          installPhase = ''
            runHook preInstall
            
            # Create Wine prefix for 64-bit installation
            export WINEPREFIX=$out/wineprefix
            mkdir -p $WINEPREFIX
            export WINEARCH=win64
            wineboot --init
            
            # Extract the installer zip
            unzip -q $src -d $out/extracted
            
            # List contents to find the actual installer
            ls -la $out/extracted
            
            # Run the installer with Wine (silent mode)
            cd $out/extracted
            wine RGC-Setup.exe /S || wine RGC-Setup.exe /verysilent || wine RGC-Setup.exe /silent
            
            # Find and wrap the installed executable
            mkdir -p $out/bin
            cp -r $out/extracted/RGC* $out/bin/ 2>/dev/null || true
            
            # If no RGC* found, try to find any .exe in extracted
            if [ ! -d "$out/bin/RGC" ]; then
              find $out/extracted -name "*.exe" -type f | head -1 | xargs -I {} cp {} $out/bin/ 2>/dev/null || true
            fi
            
            # Wrap the executable to ensure Wine is in PATH
            wrapProgram $out/bin/RGC.exe \
              --prefix PATH : ${pkgs.wine}/bin \
              --prefix WINEPREFIX : $WINEPREFIX
            
            runHook postInstall
          '';

        };

      in {
        packages.rgc = rgc;
        defaultPackage = rgc;
      }
    );
}

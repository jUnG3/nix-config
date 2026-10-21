{
  description = "NixOS Config for junge (Hyprland + btrfs)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-amd-ai.url = "github:noamsto/nix-amd-ai";
    opencode.url = "github:anomalyco/opencode/v2.1.2";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nix-amd-ai,
      opencode,
      ...
    }:
    let
      system = "x86_64-linux";
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.workhorse = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit unstable;
          inherit opencode;
        };
        modules = [
          /etc/nixos/hardware-configuration.nix
          ./configuration.nix
          nix-amd-ai.nixosModules.default
        ];
      };
    };
}

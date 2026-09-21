{
  description = "NixOS Config for junge (Hyprland + btrfs)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-amd-ai.url = "github:noamsto/nix-amd-ai";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nix-amd-ai,
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
        specialArgs = { inherit unstable; };
        modules = [
          /etc/nixos/hardware-configuration.nix
          ./configuration.nix
          nix-amd-ai.nixosModules.default
        ];
      };
    };
}

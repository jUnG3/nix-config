{
  description = "NixOS Config for junge (Hyprland + btrfs)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, nixpkgs-unstable, ... }:
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
        ];
      };
    };
}

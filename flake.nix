{
  description = "NixOS Config for junge (Hyprland + btrfs)";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      ...
    }:
    let
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      system = "x86_64-linux";
    in
    {
      nixosConfigurations."workhorse" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          /etc/nixos/hardware-configuration.nix
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.junge = import ./home.nix;
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit unstable;
              };
            };
          }
        ];
      };
    };
}

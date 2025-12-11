{
  description = "NixOS Config for junge (Hyprland + btrfs)";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hardware-config.url = "path:/etc/nixos/hardware-configuration.nix";
  };

  outputs = {self, nixpkgs, home-manager, hardware-config, ...}:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations."workhorse" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        hardware-config
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.users.junge = import ./home.nix;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}

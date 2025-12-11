{ config, pkgs, ... }:

{
  home.username = "junge";
  home.homeDirectory = "/home/junge";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    alacritty
    wofi
    waybar
    swww
    hyprpaper
    git
    nixpkgs-fmt
    keepassxc
    git-credential-keepassxc
    ranger
    bat
    neovim
    spotify

    gcc
    gdb
    valgrind
    cmake
    meson
    ninja
    pkg-config
    ccache

    jdk21
    gradle
  ];

  xdg.configFile."hypr/hyprland.conf".source = ./hyprland/hyprland.conf;

  xdg.configFile."waybar/config".source = ./waybar/config;

  xdg.configFile."waybar/style.css".source = ./waybar/style.css;

  xdg.configFile."wofi/power.sh" = {
    executable = true;
    source = ./wofi/power.sh;
  };

}

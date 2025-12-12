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
    discord
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = { # "ohMyZsh" without Home Manager
      enable = true;
      plugins = [ "git" "thefuck" "docker" ];
      theme = "robbyrussell";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [
      "--preview 'head {}'"
    ];
    historyWidgetOptions = [
      "--preview 'head {}'"
    ];
  };

  xdg.configFile."hypr/hyprland.conf".source = ./hyprland/hyprland.conf;

  xdg.configFile."waybar/config".source = ./waybar/config;

  xdg.configFile."waybar/style.css".source = ./waybar/style.css;

  xdg.configFile."wofi/power.sh" = {
    executable = true;
    source = ./wofi/power.sh;
  };

}

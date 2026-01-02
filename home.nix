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
    clang-tools
    gdb
    valgrind
    cmake
    meson
    ninja
    pkg-config
    ccache
    lua-language-server
    yaml-language-server
    ripgrep

    jdk21
    python315
    gradle
    discord
    fd
    pass
    rofi-pass
    wtype
    wl-clipboard
    gnupg
    steam
    naps2
    file
    samba

    # support both 32-bit and 64-bit applications
    wine
    winetricks

    vulkan-loader
    libGL
    wayland

    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXi
    xorg.libXpresent
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXfixes
    xorg.libxcb
    unrar
    protontricks
    cdrtools
    steam-run
    unzip
    zip
    wf-recorder
    obs-studio
    slurp
    mc
    ranger
    lf
    lsof
    kodi
    shotwell

    rclone
    fuse3
    libsecret
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = { # "ohMyZsh" without Home Manager
      enable = true;
      plugins = [ "git" "docker" ];
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

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;   # for Hyprland/Wayland
    theme = "rounded-nord-dark.rasi";          # loads ~/.config/rofi/themes/tokyonight.rasi
    extraConfig = {
      modi = "drun,run,window,ssh";
      show-icons = true;
    };
    pass.package = pkgs.rofi-pass;
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;     # you said SSH part is already done
    pinentryPackage = pkgs.pinentry-gnome3;  # or pinentry-qt / pinentry-curses
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      preload = [
        "$HOME/Pictures/wallpapers/jacob-bentzinger-OrovnGeyG-A-unsplash.jpg"
      ];
      wallpaper = [
        ",$HOME/Pictures/wallpapers/jacob-bentzinger-OrovnGeyG-A-unsplash.jpg"
      ];
    };
  };
  systemd.user.services.hyprpaper = {
    Install.WantedBy = [ "default.target" ];
  };
  programs.emacs = {
    enable = true;
  };

  xdg.configFile."hypr/hyprland.conf".source = ./hyprland/hyprland.conf;

  xdg.configFile."waybar/config".source = ./waybar/config;

  xdg.configFile."waybar/style.css".source = ./waybar/style.css;

  xdg.configFile."wofi/power.sh" = {
    executable = true;
    source = ./wofi/power.sh;
  };

  xdg.configFile."rofi/themes/rounded-nord-dark.rasi".source =
    ./rofi-themes-collection/themes/rounded-nord-dark.rasi;
  xdg.configFile."rofi/themes/template/rounded-template.rasi".source = ./rofi-themes-collection/themes/template/rounded-template.rasi;

xdg.configFile."rofi-pass/config".text = ''
# Use rofi as the UI
ROFI_CMD="rofi -dmenu -i"

# Clipboard handling on Wayland
CLIP_CMD="wl-copy"
CLIP_CLEAR_CMD="wl-copy -c"

# Clear clipboard after N seconds
CLIP_TIME=15

# Type password (Wayland)
TYPE_CMD="wtype"

# Default action:
#   - If you want "copy password" by default, keep it like this.
# rofi-pass supports multiple actions via keybinds in the menu.
DEFAULT_ACTION="copy"

# Store location (default is ~/.password-store; set only if custom)
PASSWORD_STORE_DIR="$HOME/.password-store"
'';

  xdg.configFile."emacs/init.el".source = ./emacs/init.el;
}

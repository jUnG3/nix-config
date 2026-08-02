{ pkgs, unstable, ... }:

let
  username = "junge";
  homeDirectory = "/home/${username}";
  mountPoint = "${homeDirectory}/mnt/ivana-slike";

  rofiPassConfig = pkgs.writeText "rofi-pass-config" ''
    ROFI_CMD="rofi -dmenu -i"
    CLIP_CMD="wl-copy"
    CLIP_CLEAR_CMD="wl-copy -c"
    CLIP_TIME=15
    TYPE_CMD="wtype"
    DEFAULT_ACTION="copy"
    PASSWORD_STORE_DIR="$HOME/.password-store"
  '';

  alacrittyConfig = pkgs.writeText "alacritty.toml" ''
    [window]
    opacity = 0.9

    [font]
    size = 12

    [font.normal]
    family = "FiraCode Nerd Font"
    style = "Regular"

    [font.italic]
    family = "FiraCode Nerd Font"
    style = "Italic"

    [font.bold]
    family = "FiraCode Nerd Font"
    style = "Bold"
  '';

  kittyConfig = pkgs.writeText "kitty.conf" ''
    font_family FiraCode Nerd Font
    font_size 12
    background_opacity 0.9
  '';

  ncmpcppConfig = pkgs.writeText "ncmpcpp-config" ''
    mpd_host = "127.0.0.1"
    mpd_port = "6600"
    autocenter_mode = "yes"
    centered_cursor = "yes"
    user_interface = "alternative"
  '';

  mpdConfig = pkgs.writeText "mpd.conf" ''
    music_directory "${homeDirectory}/Music"
    playlist_directory "${homeDirectory}/.local/share/mpd/playlists"
    db_file "${homeDirectory}/.local/share/mpd/database"
    state_file "${homeDirectory}/.local/share/mpd/state"
    sticker_file "${homeDirectory}/.local/share/mpd/sticker.sql"
    pid_file "${homeDirectory}/.local/share/mpd/pid"
    bind_to_address "127.0.0.1"
    port "6600"

    audio_output {
      type "pulse"
      name "My PulseAudio"
    }
  '';

  mimeApps = pkgs.writeText "mimeapps.list" ''
    [Added Associations]
    application/pdf=org.kde.okular.desktop;

    [Default Applications]
    application/pdf=org.kde.okular.desktop;
    image/jpeg=imv.desktop;
    image/png=imv.desktop;
    image/webp=imv.desktop;
  '';

  gtk3Settings = pkgs.writeText "gtk3-settings.ini" ''
    [Settings]
    gtk-theme-name=Adwaita-dark
    gtk-application-prefer-dark-theme=1
  '';

  gtk4Settings = pkgs.writeText "gtk4-settings.ini" ''
    [Settings]
    gtk-theme-name=Adwaita-dark
    gtk-application-prefer-dark-theme=1
  '';

  qt5ctConfig = pkgs.writeText "qt5ct.conf" ''
    [Appearance]
    style=Breeze
  '';

  qt6ctConfig = pkgs.writeText "qt6ct.conf" ''
    [Appearance]
    style=Breeze
  '';

  hyprpaperConfig = pkgs.writeText "hyprpaper.conf" ''
    ipc = on
    preload = ${homeDirectory}/Pictures/wallpapers/jacob-bentzinger-OrovnGeyG-A-unsplash.jpg
    wallpaper = ,${homeDirectory}/Pictures/wallpapers/jacob-bentzinger-OrovnGeyG-A-unsplash.jpg
  '';
in
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking = {
    hostName = "workhorse";
    networkmanager.enable = true;
  };

  programs = {
    ssh.startAgent = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "docker"
        ];
        theme = "robbyrussell";
      };
      interactiveShellInit = ''
        source ${pkgs.fzf}/share/fzf/completion.zsh
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        export FZF_CTRL_T_COMMAND='fd --type f'
        export FZF_CTRL_T_OPTS="--preview 'head {}'"
        export FZF_CTRL_R_OPTS="--preview 'head {}'"
      '';
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      package = unstable.neovim-unwrapped;
      configure.packages.home-manager-migration = {
        start = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
      };
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    gamemode.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    dconf.enable = true;

    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };

  time.timeZone = "Europe/Zagreb";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings.LC_ALL = "en_US.UTF-8";
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "amd_pstate=active" ];
    initrd.kernelModules = [ "amdgpu" ];
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    sane.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        pkgs.rocmPackages.clr.icd
        pkgs.rocmPackages.hipcc
      ];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  users = {
    users.${username} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "input"
        "scanner"
        "lpadmin"
      ];
    };
    defaultUserShell = pkgs.zsh;
    mutableUsers = true;
  };

  security.rtkit.enable = true;

  services = {
    pulseaudio.enable = false;
    blueman.enable = true;
    openssh.enable = false;
    usbmuxd.enable = true;

    xserver = {
      enable = false;
      videoDrivers = [ "amdgpu" ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };

    printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin ];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
    ];
    fontconfig.defaultFonts = {
      serif = [ "Fira Code" ];
      sansSerif = [ "Fira Code" ];
      monospace = [ "Fira Code Mono" ];
    };
  };

  environment = {
    variables = {
      GTK_THEME = "Adwaita-dark";
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };

    systemPackages = with pkgs; [
      vim
      emacs
      git
      wget
      htop
      btop
      aider-chat
      alacritty
      kitty
      wofi
      rofi
      rofi-pass
      waybar
      swww
      hyprpaper
      hyprlock
      hyprshot
      dunst
      firefox
      foot
      keepassxc
      git-credential-keepassxc
      ranger
      yazi
      bat
      spotify
      kdePackages.kdenlive
      gnucash
      libreoffice-still
      audacity
      ffmpeg-full

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
      stylua
      yaml-language-server
      ripgrep
      fd
      nodejs
      python3

      jdk21
      jdt-language-server
      python315
      gradle
      discord
      pass
      wtype
      wl-clipboard
      gnupg
      naps2
      file
      samba

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
      wl-kbptr
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
      lf
      lsof
      kodi
      shotwell
      imv
      lazygit

      rclone
      fuse3
      libsecret
      ncmpcpp
      mpc
      mpd
      krita
      libnotify
      transmission_4
      kdePackages.okular
      qt6Packages.qt6ct
      kdePackages.breeze
      libsForQt5.qt5ct
      nixfmt-rfc-style
      nixd
      statix
      nixpkgs-fmt

      slack
      pavucontrol
      pulseaudio
      blueman
      gnome-themes-extra
      pinentry-gnome3

      wineWow64Packages.unstable
      lutris
      winetricks
    ];
  };

  # Home Manager used to create these files. NixOS tmpfiles now installs
  # equivalent symlinks into junge's home directory.
  systemd.tmpfiles.rules = [
    "d ${homeDirectory}/.config 0755 ${username} users -"
    "d ${homeDirectory}/.config/hypr 0755 ${username} users -"
    "d ${homeDirectory}/.config/waybar 0755 ${username} users -"
    "d ${homeDirectory}/.config/wofi 0755 ${username} users -"
    "d ${homeDirectory}/.config/rofi/themes/template 0755 ${username} users -"
    "d ${homeDirectory}/.config/rofi-pass 0755 ${username} users -"
    "d ${homeDirectory}/.config/emacs 0755 ${username} users -"
    "d ${homeDirectory}/.config/wl-kbptr 0755 ${username} users -"
    "d ${homeDirectory}/.config/alacritty 0755 ${username} users -"
    "d ${homeDirectory}/.config/kitty 0755 ${username} users -"
    "d ${homeDirectory}/.config/ncmpcpp 0755 ${username} users -"
    "d ${homeDirectory}/.config/gtk-3.0 0755 ${username} users -"
    "d ${homeDirectory}/.config/gtk-4.0 0755 ${username} users -"
    "d ${homeDirectory}/.config/qt5ct 0755 ${username} users -"
    "d ${homeDirectory}/.config/qt6ct 0755 ${username} users -"
    "d ${homeDirectory}/.local/share/mpd/playlists 0755 ${username} users -"
    "d ${mountPoint} 0700 ${username} users -"

    "L+ ${homeDirectory}/.config/hypr/hyprland.conf - - - - ${./hyprland/hyprland.conf}"
    "L+ ${homeDirectory}/.config/waybar/config - - - - ${./waybar/config}"
    "L+ ${homeDirectory}/.config/waybar/style.css - - - - ${./waybar/style.css}"
    "L+ ${homeDirectory}/.config/wofi/power.sh - - - - ${./wofi/power.sh}"
    "L+ ${homeDirectory}/.config/rofi/themes/rounded-nord-dark.rasi - - - - ${./rofi-themes-collection/themes/rounded-nord-dark.rasi}"
    "L+ ${homeDirectory}/.config/rofi/themes/template/rounded-template.rasi - - - - ${./rofi-themes-collection/themes/template/rounded-template.rasi}"
    "L+ ${homeDirectory}/.config/rofi-pass/config - - - - ${rofiPassConfig}"
    "L+ ${homeDirectory}/.config/emacs/init.el - - - - ${./emacs/init.el}"
    "L+ ${homeDirectory}/.config/wl-kbptr/config - - - - ${./wl-kbptr/config}"
    "L+ ${homeDirectory}/.config/alacritty/alacritty.toml - - - - ${alacrittyConfig}"
    "L+ ${homeDirectory}/.config/kitty/kitty.conf - - - - ${kittyConfig}"
    "L+ ${homeDirectory}/.config/ncmpcpp/config - - - - ${ncmpcppConfig}"
    "L+ ${homeDirectory}/.config/mimeapps.list - - - - ${mimeApps}"
    "L+ ${homeDirectory}/.config/gtk-3.0/settings.ini - - - - ${gtk3Settings}"
    "L+ ${homeDirectory}/.config/gtk-4.0/settings.ini - - - - ${gtk4Settings}"
    "L+ ${homeDirectory}/.config/qt5ct/qt5ct.conf - - - - ${qt5ctConfig}"
    "L+ ${homeDirectory}/.config/qt6ct/qt6ct.conf - - - - ${qt6ctConfig}"
  ];

  systemd.user.services = {
    desktop-preferences = {
      description = "Apply GTK and cursor preferences";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "desktop-preferences" ''
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme prefer-dark
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme ArcStarry
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-size 24
        '';
      };
    };

    hyprpaper = {
      description = "Hyprpaper wallpaper daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper --config ${hyprpaperConfig}";
        Restart = "on-failure";
      };
    };

    dunst = {
      description = "Dunst notification daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.dunst}/bin/dunst";
        Restart = "on-failure";
      };
    };

    mpd = {
      description = "Music Player Daemon";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon ${mpdConfig}";
        Restart = "on-failure";
      };
    };

    rclone-gdrive = {
      description = "Rclone mount: Google Drive (config from Secret Service)";
      wantedBy = [ "default.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStartPre = pkgs.writeShellScript "rclone-secret-prep" ''
          set -euo pipefail
          umask 077

          runtime_dir="$XDG_RUNTIME_DIR/rclone"
          runtime_conf="$runtime_dir/rclone.conf"

          mkdir -p "$runtime_dir" "${mountPoint}"
          chmod 700 "$runtime_dir" "${mountPoint}"

          conf="$(${pkgs.libsecret}/bin/secret-tool lookup service rclone name ivana-photos-conf 2>/dev/null || true)"
          if [ -z "$conf" ]; then
            echo "ERROR: Could not retrieve secret (service=rclone name=ivana-photos-conf)."
            echo "Check: KeePassXC running + DB unlocked + Secret Service enabled."
            exit 1
          fi

          printf "%s\n" "$conf" > "$runtime_conf"
          chmod 600 "$runtime_conf"
        '';
        ExecStart = pkgs.writeShellScript "rclone-mount-gdrive" ''
          set -euo pipefail
          runtime_conf="$XDG_RUNTIME_DIR/rclone/rclone.conf"

          exec ${pkgs.rclone}/bin/rclone mount ivana-photos: ${mountPoint} \
            --config "$runtime_conf" \
            --vfs-cache-mode writes \
            --dir-cache-time 72h \
            --poll-interval 1m \
            --umask 077
        '';
        ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u ${mountPoint}";
        Restart = "on-failure";
        RestartSec = 3;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}

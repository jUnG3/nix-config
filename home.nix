{ config, pkgs, ... }:

let
  mountPoint = "${config.home.homeDirectory}/mnt/ivana-slike";
in
{
  home = {
    username = "junge";
    homeDirectory = "/home/junge";
    stateVersion = "25.11";
  };

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
    yazi
    bat
    spotify
    kdePackages.kdenlive
    gnucash
    libreoffice
    audacity
    ffmpeg-full
    hyprshot

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

    jdk21
    jdt-language-server
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
    lutris
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
    imv
    lazygit

    rclone
    fuse3
    libsecret

    ncmpcpp
    mpc
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

    slack
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark"; # THIS is the important one for GTK4/libadwaita
        gtk-theme = "Adwaita-dark"; # helps GTK3 apps
      };
    };
  };

  xdg = {
    enable = true;
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    mimeApps = {
      enable = true;
      associations.added = {
        "application/pdf" = [ "org.kde.okular.desktop" ];
      };
      defaultApplications = {
        "application/pdf" = [ "org.kde.okular.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/webp" = [ "imv.desktop" ];
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk3.extraConfig."gtk-application-prefer-dark-theme" = 1;
    gtk4.extraConfig."gtk-application-prefer-dark-theme" = 1;
  };

  services = {
    ollama = {
      enable = true;
      acceleration = "rocm";
      package = pkgs.ollama-rocm;
      environmentVariables = {
        HSA_OVERRIDE_GFX_VERSION = "10.1.0";
        OLLAMA_CONTEXT_LENGTH = "2048";
        OLLAMA_FLASH_ATTENTION = "false";
        OLLAMA_HOST = "127.0.0.1:11434";
        OLLAMA_MAX_LOADED_MODELS = "1";
        OLLAMA_NUM_PARALLEL = "1";
        OLLAMA_KEEP_ALIVE = "0";
      };
    };
  };

  programs = {
    aider-chat = {
      enable = true;
    };
    btop = {
      enable = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;

      extraPackages = with pkgs; [
        git
        ripgrep
        fd

        # optional but commonly needed by plugins/tools
        nodejs
        python3
      ];
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        # "ohMyZsh" without Home Manager
        enable = true;
        plugins = [
          "git"
          "docker"
        ];
        theme = "robbyrussell";
      };
    };
    fzf = {
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

    rofi = {
      enable = true;
      package = pkgs.rofi; # for Hyprland/Wayland
      theme = "rounded-nord-dark.rasi"; # loads ~/.config/rofi/themes/tokyonight.rasi
      extraConfig = {
        modi = "drun,run,window,ssh";
        show-icons = true;
      };
      pass.package = pkgs.rofi-pass;
    };

    gpg = {
      enable = true;
    };

    emacs = {
      enable = true;
    };

    kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font";
        size = 12;
      };
      settings = {
        background_opacity = 0.9;
      };
    };

    alacritty = {
      enable = true;
      settings = {
        window.opacity = 0.9;
        font = {
          size = 12;
          normal = {
            family = "FiraCode Nerd Font";
            style = "Regular";
          };
          italic = {
            family = "FiraCode Nerd Font";
            style = "Italic";
          };
          bold = {
            family = "FiraCode Nerd Font";
            style = "Bold";
          };
        };
      };
    };
    ncmpcpp = {
      enable = true;
      settings = {
        mpd_host = "127.0.0.1";
        mpd_port = "6600";
        autocenter_mode = "yes";
        centered_cursor = "yes";
        user_interface = "alternative";
      };
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style.name = "Breeze Dark";
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = false; # you said SSH part is already done
      pinentry.package = pkgs.pinentry-gnome3; # or pinentry-qt / pinentry-curses
    };

    hyprpaper = {
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

    mpd = {
      enable = true;

      musicDirectory = "/home/junge/Music";
      extraConfig = ''
        audio_output {
          type "pulse"
          name "My PulseAudio" # this can be whatever you want
        }
      '';
    };

    dunst = {
      enable = true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    settings = {
      exec-once = [
        # Fixes cursor themes in gnome apps under hyprland
        "gsettings set org.gnome.desktop.interface cursor-theme ArcStarry"
        "gsettings set org.gnome.desktop.interface cursor-size 24"
      ];
    };
  };

  xdg = {
    configFile = {
      "hypr/hyprland.conf".source = ./hyprland/hyprland.conf;

      "waybar/config".source = ./waybar/config;

      "waybar/style.css".source = ./waybar/style.css;

      "wofi/power.sh" = {
        executable = true;
        source = ./wofi/power.sh;
      };

      "rofi/themes/rounded-nord-dark.rasi".source =
        ./rofi-themes-collection/themes/rounded-nord-dark.rasi;
      "rofi/themes/template/rounded-template.rasi".source =
        ./rofi-themes-collection/themes/template/rounded-template.rasi;

      "rofi-pass/config".text = ''
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

      "emacs/init.el".source = ./emacs/init.el;
    };
  };

  systemd.user.services.rclone-gdrive = {
    Unit = {
      Description = "Rclone mount: Google Drive (config from Secret Service)";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";

      ExecStartPre = pkgs.writeShellScript "rclone-secret-prep" ''
        set -euo pipefail
        umask 077

        if [ -z "''${XDG_RUNTIME_DIR:-}" ]; then
          echo "ERROR: XDG_RUNTIME_DIR is not set."
          exit 1
        fi

        runtime_dir="$XDG_RUNTIME_DIR/rclone"
        runtime_conf="$runtime_dir/rclone.conf"

        mkdir -p "$runtime_dir"
        chmod 700 "$runtime_dir"

        conf="$(${pkgs.libsecret}/bin/secret-tool lookup service rclone name ivana-photos-conf 2>/dev/null || true)"
        if [ -z "$conf" ]; then
          echo "ERROR: Could not retrieve secret (service=rclone name=ivana-photos-conf)."
          echo "Check: KeePassXC running + DB unlocked + Secret Service enabled."
          exit 1
        fi

        printf "%s\n" "$conf" > "$runtime_conf"
        chmod 600 "$runtime_conf"

        echo "Wrote rclone.conf to $runtime_conf"
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

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

}

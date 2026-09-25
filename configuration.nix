{
  config,
  pkgs,
  unstable,
  opencode,
  ...
}:

let
  username = "junge";
  homeDirectory = "/home/${username}";
  wallpapers = import ./wallpapers.nix { inherit pkgs; };

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

  hyprpaperConfig = pkgs.writeText "hyprpaper.conf" ''
    ipc = on

    wallpaper {
      monitor = DP-1
      path = ${wallpapers.devotion}
      fit_mode = cover
    }

    wallpaper {
      monitor = DP-2
      path = ${wallpapers.queenOfHeavenAndEarth}
      fit_mode = cover
    }
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
        export FZF_CTRL_R_OPTS=""
      '';
    };

    # LazyVim manages all Neovim plugins itself through lazy.nvim.
    # Do not inject Vim plugins through the NixOS Neovim wrapper.
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      package = unstable.neovim-unwrapped;
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

    git = {
      enable = true;
      package = pkgs.git.override { withLibsecret = true; };
      config = {
        credential.helper = "libsecret";
      };
    };

    light = {
      enable = true;
    };

    gamescope = {
      enable = true;
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
    extraModulePackages = with config.boot.kernelPackages; [
      yt6801
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amd_pstate=active"
      "yt6801"
    ];
    initrd = {
      kernelModules = [ "amdgpu" ];
    };
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
    amd-npu = {
      enable = true;
      enableNPU = true; # default; set false for GPU-only hosts (see "Other hardware")
      enableFastFlowLM = true; # LLM inference on NPU (requires enableNPU)
      enableLemonade = true; # OpenAI-compatible API server
      enableROCm = true; # ROCm GPU backends (llamacpp + sd-cpp)
      enableVulkan = true; # Vulkan GPU backends (llamacpp + whispercpp)
      enableImageGen = true; # default true; set false to drop sd-cpp from closure
      lemonade = {
        user = "junge";
        models = [
          "Flux-2-Klein-4B"
          "Qwen3.5-35B-A3B-GGUF"
          "qwen3.5-9b-FLM"
        ];
      };
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
        "render"
      ];
    };
    defaultUserShell = pkgs.zsh;
    mutableUsers = true;
  };

  security = {
    rtkit.enable = true;
  };

  services = {
    pulseaudio.enable = false;
    blueman.enable = true;
    openssh.enable = false;
    usbmuxd.enable = true;

    xserver = {
      enable = false;
      videoDrivers = [ "amdgpu" ];
      xkb = {
        model = "pc105";
        layout = "tuxedo_colemak_ansi";
        variant = "basic";

        extraLayouts.tuxedo_colemak_ansi = {
          description = "TUXEDO PR 106 Laser Colemak-DH ANSI";
          languages = [ "eng" ];
          symbolsFile = pkgs.writeText "tuxedo_colemak_ansi" ''
            partial alphanumeric_keys
            xkb_symbols "basic" {
              include "us(basic)"
              name[Group1] = "TUXEDO PR 106 Laser Colemak-DH ANSI";

              key <AD01> { [ q, Q ] };
              key <AD02> { [ w, W ] };
              key <AD03> { [ f, F ] };
              key <AD04> { [ p, P ] };
              key <AD05> { [ b, B ] };
              key <AD06> { [ j, J ] };
              key <AD07> { [ l, L ] };
              key <AD08> { [ u, U ] };
              key <AD09> { [ y, Y ] };
              key <AD10> { [ apostrophe, quotedbl ] };
              key <AD11> { [ bracketleft, braceleft ] };
              key <AD12> { [ bracketright, braceright ] };
              key <BKSL> { [ backslash, bar ] };

              key <AC01> { [ a, A ] };
              key <AC02> { [ r, R ] };
              key <AC03> { [ s, S ] };
              key <AC04> { [ t, T ] };
              key <AC05> { [ g, G ] };
              key <AC06> { [ m, M ] };
              key <AC07> { [ n, N ] };
              key <AC08> { [ e, E ] };
              key <AC09> { [ i, I ] };
              key <AC10> { [ o, O ] };
              key <AC11> { [ semicolon, colon ] };

              key <AB01> { [ z, Z ] };
              key <AB02> { [ x, X ] };
              key <AB03> { [ c, C ] };
              key <AB04> { [ d, D ] };
              key <AB05> { [ v, V ] };
              key <AB06> { [ k, K ] };
              key <AB07> { [ h, H ] };
              key <AB08> { [ comma, less ] };
              key <AB09> { [ period, greater ] };
              key <AB10> { [ slash, question ] };
            };
          '';
        };
      };
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
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'uwsm start hyprland-uwsm.desktop'";
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

    ollama = {
      enable = true;
      loadModels = [
        "qwen3-coder:30b"
        "llama3.1:8b"
      ];
    };
  };

  virtualisation = {
    docker = {
      enable = true;

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      Hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];

        "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
      };
    };
  };

  console = {
    earlySetup = true;
    useXkbConfig = true;
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

    sessionVariables = {
      HYPRLAND_CONFIG = "/etc/${config.environment.etc."hypr".target}/hyprland.lua";
      KITTY_CONFIG_DIRECTORY = "/etc/${config.environment.etc."kitty".target}";
      LOMBOK_JAR = "${pkgs.lombok}/share/java/lombok.jar";
    };

    etc = {
      "hypr".source = ./hyprland;
      "rofi/theme.rasi".source = ./rofi/catppuccin-mocha.rasi;
      "rofi/config.rasi".text = ''
        configuration {
          location: 0;
          modi: "drun,run,window,ssh";
          show-icons: true;
          xoffset: 0;
          yoffset: 0;
        }
        @theme "/etc/rofi/theme.rasi"
      '';
      "xdg/waybar".source = ./waybar;
      "kitty".source = ./kitty;
    };

    systemPackages = with pkgs; [
      vim
      fzf
      emacs
      git
      wget
      curl
      htop
      btop
      aider-chat
      alacritty
      kitty
      wofi
      rofi
      rofi-pass
      waybar
      quickshell
      awww
      hyprpaper
      hyprlock
      hyprshot
      dunst
      firefox
      newsflash
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
      satty
      grim
      gpclient
      gnutar
      brightnessctl

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
      tree-sitter

      jdk21
      jdt-language-server
      lombok
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
      libx11
      libxcursor
      libxrandr
      libxinerama
      libxi
      libxpresent
      libxcomposite
      libxdamage
      libxfixes
      libxcb
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
      nixfmt
      nixd
      statix
      nixpkgs-fmt

      slack
      (llm.withPlugins {
        llm-ollama = true;
      })
      pavucontrol
      pulseaudio
      blueman
      gnome-themes-extra
      pinentry-gnome3

      wine
      lutris
      winetricks
      nvtopPackages.amd
      opencode.packages.${pkgs.stdenv.hostPlatform.system}.default
      playwright

      dotnet-sdk_10
      dotnet-runtime_10
      dotnet-aspnetcore_10
    ];
  };

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
        ExecStartPre = pkgs.writeShellScript "prepare-mpd-directories" ''
          mkdir -p \
            ${homeDirectory}/.local/share/mpd/playlists \
            ${homeDirectory}/Music
        '';
        ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon ${mpdConfig}";
        Restart = "on-failure";
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}

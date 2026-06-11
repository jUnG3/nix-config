{ pkgs, ... }:

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
    zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    gamemode = {
      enable = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    dconf = {
      enable = true;
    };
    hyprland = {
      enable = true;
      withUWSM = true;
    };
  };

  time.timeZone = "Europe/Zagreb";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ALL = "en_US.UTF-8";
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [
      "amd_pstate=active"
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
      # Optional but nice (battery reporting, etc.)
      settings.General = {
        Experimental = true;
      };
    };
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  users = {
    users.junge = {
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
    mutableUsers = true;
  };

  services = {
    pulseaudio.enable = false;
    blueman.enable = true;
    openssh.enable = false;
    rtkit.enable = true;

    usbmuxd = {
      enable = true;
    };

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

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Fira Code" ];
        sansSerif = [ "Fira Code" ];
        monospace = [ "Fira Code Mono" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    emacs
    git
    wget
    htop
    alacritty
    waybar
    hyprlock
    firefox
    foot
    libreoffice-still

    pavucontrol
    pulseaudio
    blueman
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";

}

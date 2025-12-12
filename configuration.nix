{ config, pkgs, ...}:

{
  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking = {
    hostName = "workhorse";
    networkmanager.enable = true;
  };

  programs.ssh.startAgent = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  time.timeZone = "Europe/Zagreb";

  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hardware.cpu.amd.updateMicrocode = true;
  boot.kernelParams = [
    "amd_pstate=active"
  ];
  powerManagement.cpuFreqGovernor = "schedutil";

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  programs.gamemode.enable = true;

  users.users.junge = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "audio" "video" "input"];
  };

  users.mutableUsers = true;

  services.pulseaudio.enable = false;
  services.blueman.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    # Optional but nice (battery reporting, etc.)
    settings.General = {
      Experimental = true;
    };
  };

  services.xserver.enable = false;
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "Hyprland";
      user = "junge";
    };
  };
  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.systemPackages = with pkgs; [
    vim
    emacs
    git
    wget
    htop
    alacritty
    waybar
    hyprpaper
    hyprlock
    firefox
    foot
    libreoffice-still

    pavucontrol
    pulseaudio
    blueman
  ];

  services.openssh.enable = false;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
    ];

    fontconfig = {
      defaultFonts = {
        serif = [  "Fira Code" ];
        sansSerif = [ "Fira Code" ];
        monospace = [ "Fira Code Mono" ];
      };
    };
  };
}

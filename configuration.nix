# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

  let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  imports =
    [ # Include the results of the hardware scan.
      # <nixos-hardware/dell/xps>  # not merged in yet. :(
      ./hardware-configuration.nix
      ./system-id.nix
      ./xmonad.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # zfs
  boot.supportedFilesystems = [ "zfs" ];

  # networking.hostId = "1EA29BFF";
  # networking.hostName = "dawn-treader"; # Define your hostname.

  #networking.networkmanager.enable = true;  # Enables wireless support via wpa_supplicant.
  #programs.nm-applet.enable=true;
  networking.wireless={
    enable=true;
    userControlled.enable=true;
    networks={
        "Beckman Park"={
           #psk="2249350444"
           pskRaw="bb37420e272e4f8c962add9e341bb817168b801cb79ab7b394fb372a163b0578";
        };
        IllinoisNet={
           #pskRaw="e7afb8f6f7834910f5925a45b0066cc92cfd627f99c95286b5e9ac3b82594a8f";
           auth=''
               eap=PEAP
               identity="mattox"
               password="XvYaltaGrimPrefixHymnal42"
               phase2="auth=MSCHAPV2"
               auth_alg=OPEN
               key_mgmt=WPA-EAP
            '';
        };
        "Mattox's Galaxy S21 5G"={
           psk="2249350444";
        };

    };
  };


  # Set your time zone.
  time.timeZone = "America/Chicago";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

   #Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ALL="POSIX";
  };


  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable postgres

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE USER mattox SUPERUSER CREATEDB;
    '';
  };


  # Enable the X11 windowing system.
  services.xserver = {
     dpi=120;
     enable = true;
     xkbOptions = "caps:swapescape";
     monitorSection = ''
        DisplaySize 366 229
     '';
  };


  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  # Cron
  
  services.cron = {
    enable = true;
    systemCronJobs = [
       "*/15 * * * *    root  zfs-autobackup snap"
    ];
  };

  # Systemd

  systemd = {
    timers.rsync-backup = {
      wantedBy = [ "timers.target" ];
      partOf = [ "simple-timer.service" ];
      timerConfig.OnCalendar = "*-*-* 23:00:00";
    };
    services.rsync-backup = {
      serviceConfig.Type = "oneshot";
      script = ''
        /run/current-system/sw/bin/zsh /home/mattox/backups/run-backups
      '';
    };
  };


  # Bluetooth

  hardware.bluetooth.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mattox = {
    isNormalUser = true;
    description = "Mattox Beckman";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "audio" "wheel" ]; # Enable ‘sudo’ for the user.
  };

  security.sudo.wheelNeedsPassword = false;

  # My overlays

  nixpkgs.overlays = import /home/mattox/Apps/nixpkg-overlays;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    brave

    # Editing
    vim 
    emacs

    # Administration
    stow
    wget
    zfs-autobackup
    git

    # System
    networkmanagerapplet
    wpa_supplicant_gui
    killall
    libnotify
    alacritty
    tmux
    fzf
    htop
    ripgrep
    silver-searcher
    direnv
    keychain
    ksshaskpass
    xclip
    appimage-run
    pavucontrol
    gnumake
    hugo
    go
    xorg.xdpyinfo
    sqlite

    # Applications
    logseq
    unstable.zoom-us
    direnv
    taskwarrior
    tasksh
    evince
    okular
    hledger
    slack
    discord

    texlive.combined.scheme-full

    # Programming
    python3
    stack

    # xmonad
    # xmonad-with-packages
    rofi
    xmobar
    xmonad-log
    polybarFull
    nitrogen
    kdeconnect
    dunst
  ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    inconsolata
    liberation_ttf
  ];

  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.espanso.enable = true;

  # Syncthing

  services.syncthing = {
    enable = true;
    user = "mattox";
    dataDir = "/home/mattox/Synchronized";    # Default folder for new synced folders
    configDir = "/home/mattox/.config/syncthing";   # Folder for Syncthing's settings and keys
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}


{ config, lib, pkgs, ... }:

{
  security.pam.services.mattox.enableKwallet = true;

  services = {
    # gnome3.gnome-keyring.enable = true;
    upower.enable = true;
 
    dbus = {
      enable = true;
      # packages = [ pkgs.gnome3.dconf ];
    };

    xserver = {
      enable = true;
      # startDbusSession = true;
      layout = "us";

      libinput = {
        enable = true;
        touchpad.disableWhileTyping = true;
      };

      desktopManager.plasma5.enable = true;

      displayManager = {
          defaultSession = "none+xmonad";
          sddm.enable = true;
      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
          haskellPackages.xmonad
          haskellPackages.dbus
        ];
      };

      xkbOptions = "caps:swapescape";
    };

    picom = {
      enable = true;
      activeOpacity = 1.0;
      inactiveOpacity = 0.95;
      backend = "glx";
      fade = true;
      fadeDelta = 5;
      # opacityRule = [ "100:name *= 'i3lock'" ];
      shadow = true;
      shadowOpacity = 0.75;
    };
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  systemd.services.upower.enable = true;
}

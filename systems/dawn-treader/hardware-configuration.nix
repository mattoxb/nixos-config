# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "pool-dawn-treader/root";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "pool-dawn-treader/home";
      fsType = "zfs";
    };

  fileSystems."/etc" =
    { device = "pool-dawn-treader/etc";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "pool-dawn-treader/nix";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/DCEA-0E13";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/17a85f73-17f5-40b3-980e-5a55228d3f9a"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

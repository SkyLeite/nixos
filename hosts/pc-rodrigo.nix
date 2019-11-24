{ config, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  networking.hostName = "pc"; # Define your hostname.

  # Fixes for Navi stuff
  boot.kernelParams = [ "amd_iommu=pt" "ivrs_ioapic[32]=00:14.0" "iommu=soft" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.xserver.videoDrivers = [ "amdgpu" ];
  services.blueman.enable = true;

  hardware.cpu.amd.updateMicrocode = true;
  hardware.bluetooth.enable = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/3cb8bcb0-2566-4f74-bcf7-57fb1ec8645d";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/BC30-106A";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = 12;
}


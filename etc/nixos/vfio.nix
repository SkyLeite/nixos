{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.virt-manager ];

  boot = {
    kernelParams = [ "amd_iommu=on" ];
    kernelModules =
      [ "vendor-reset" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    #extraModprobeConfig = "options vfio-pci ids=1002:731f,1002:ab38";
    extraModulePackages =
      [ config.boot.kernelPackages.vendor-reset config.boot.kernelPackages.cpupower ];
  };

  programs.dconf.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemuOvmf = true;
      qemuVerbatimConfig = ''
        user = "sky"
        group = "kvm"
        cgroup_device_acl = [
            "/dev/input/by-id/usb-ZSA_Technology_Labs_Inc_ErgoDox_EZ_Glow-event-kbd",
            "/dev/input/by-id/usb-Logitech_G403_Prodigy_Gaming_Mouse_087838573135-event-mouse",
            "/dev/null", "/dev/full", "/dev/zero",
            "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
            "/dev/rtc","/dev/hpet", "/dev/sev"
        ]
      '';
    };
  };
}

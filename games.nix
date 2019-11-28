{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam
    lutris
    sc-controller
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    libstrangle
  ];

  # Enable OpenGL for 32 bit programs
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.opengl.setLdLibraryPath = true; 
  hardware.pulseaudio.support32Bit = true;
  hardware.steam-hardware.enable = true; 
  boot.kernel.sysctl = { "abi.vsyscall32" = 0; };
}


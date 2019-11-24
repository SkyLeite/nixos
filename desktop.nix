{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    i3-gaps
    i3-easyfocus
    i3-layout-manager
    i3lock-fancy
    i3status-rust
    alacritty
    lsd
    flameshot
    mesa_drivers
    dunst
    mpd
    mpd-mpris
    playerctl
    firefox
    rofi
    xclip
    font-awesome_4
  ];

  # Enable the KDE and i3 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "intl";
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.i3.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable services
  services.openssh.enable = true;
  services.mpd.enable = true;

}


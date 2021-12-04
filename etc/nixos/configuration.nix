# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  usBr = pkgs.fetchFromGitHub {
    owner = "SkyLeite";
    repo = "us-br";
    rev = "e00b23128f668d621266904f7040998bab5c6168";
    sha256 = "1az5aqhm2hmsa2a43qr5k6djnc51sqr6zl2g21zf1kjv3n57nf2i";
  };
in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [ pango libthai harfbuzz ];
    };
  };

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./vfio.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "home"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.

  networking = {
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    hosts = { };
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;
    displayManager = { 
      sddm.enable = true; 
      sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap ${usBr}/us-br";
    };
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
      gnome.enable = true;
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
    videoDrivers = [ "amdgpu" ];
  };

  services.flatpak.enable = true;
  services.blueman.enable = true;
  services.k3s.enable = false;

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "altgr-intl";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  services.udev.extraRules = ''
  SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3006", TAG+="uaccess"
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sky = {
    isNormalUser = true;
    createHome = true;
    description = "Sky Leite";
    extraGroups = [ "wheel" "docker" "libvirtd" "kvm" "input" "adbusers" "audio" ];
    group = "users";
    home = "/home/sky";
    hashedPassword =
      "$6$BxcfpoGqb.I$msdWrRc75bsmegjGBvrC.qRS1Hw5KR0OjseqTZnxoN.U7W52srD5WWT0w4Z5QhFjZaq7/gzQXQ1YUfSlvcE13.";
    uid = 1234;
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    albert
    bitwarden
    discord
    docker
    docker-compose
    dolphin
    editorconfig-core-c
    emacs
    fd
    firefox
    flameshot
    git
    gparted
    neovim
    nixfmt
    pciutils
    peek
    plasma-desktop
    python3
    ripgrep
    teams
    wget
    xclip
    virtualbox
    xorg.xkbcomp
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.steam.enable = true;
  programs.adb.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.sshd.enable = true;
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  users.extraGroups.vboxusers.members = [ "sky" ];

  services.mopidy = {
    enable = true;
    extensionPackages = [
      pkgs.mopidy-mpd
      pkgs.mopidy-scrobbler
      pkgs.mopidy-mpris
      pkgs.mopidy-local
      pkgs.mopidy-youtube
      pkgs.mopidy-spotify
    ];
    configuration = ''
      [mpd]
      enabled = true

      [youtube]
      enabled = true
    '';
    extraConfigFiles = [ "/etc/nixos/mopidy/mopidy.conf" ];
  };

  # Binary Cache for Haskell.nix
  nix.binaryCachePublicKeys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];

  nix.binaryCaches = [
    "https://hydra.iohk.io"
  ];

  nix.extraOptions = ''
	  experimental-features = nix-command flakes
	  '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall.enable = false;
  # networking.firewall.allowedTCPPorts = [ 22 80 8080 8000 11470 ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}


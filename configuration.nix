# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  users.users.mpd.extraGroups = [ "audio" ];
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rodrigo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "video" "mpd" "audio" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    initialPassword = "1234";
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hosts/pc-rodrigo.nix
      # ./games.nix
      ./desktop.nix
      ./development.nix
      ./home.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    defaultLocale = "en_US.UTF-8";
    consoleUseXkbConfig = true;
  };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget 
    wgetpaste 
    chezmoi
    zsh
    alacritty
    blueman
    yadm
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    shellAliases = {
      vim = "nvim";
    };
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "command-not-found" ];
      theme = "frisk";
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJfH2SEdZyjHcewzSPbL8jHPsGMI6UfH9V4NqPN1ZPkvG18Yy0CT2JKR6N+75rtMJiQf1BAnTWaPfV6ngZ3WdXjdeBvz726HG4W/rQlydQxux0yDGzxKKbNzyKJzWkCy/btKDshix/w2jQrW538gfvB31EPLNfwHiTkJYMn3XdcElULA/frmel+GPFXRBZ7atygCQmw5hpDJ0gD4DKtXc66JzCo7O+PgdQY2SVeUE03ByQ+fANG4jCGizqahgX7JiubaSBXbD+l5fd+0I0V06+ACwB8zerHYe2zTeBtWnjEDOXhLNinJDxV7KntlKh/0hMAOws02fizrkgQmQ8lPpo00BJyaQnPMySYeTfL33rQdTbckAScRon2xiipxGT4uk5V0q7iy1WShDyhQYCp5WprRGTs4StaBVI/80FrDEmL9jirc9BO1RCj2XkNqqGEi5Ysnz8U3kdYKW2b/jBABAlf9Ksi1/pKZk3JWQSiaIOQH8XIxKP/YvFREoXVXYlOOM= rodrigo@home" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}


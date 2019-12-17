{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Editors
    neovim
    emacs
    vscode

    # Tools
    docker
    docker-compose

    # Language-specific
    rustup
    nodejs_latest
    gnumake
    cmake
    gcc
  ];

  services.emacs.enable = true;
}

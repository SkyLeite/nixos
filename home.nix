let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "dd94a849df69fe62fe2cb23a74c2b9330f1189ed"; # CHANGEME 
    ref = "release-18.09";
  };

  dotfiles = builtins.fetchGit {
    url = "https://github.com/RodrigoLeiteF/dotfiles.git";
    rev = "6392e457019657dcca77d42c4dd5ae8ad3d35a0d";
  };
in
{
    imports = [
      "${home-manager}/nixos"
    ];

    home-manager.users.rodrigo = {
        programs.git = {
          enable = true;
          userName  = "Rodrigo Leite";
          userEmail = "rodrigo@leite.dev";
        };

        programs.zsh = {
          defaultKeymap = "viins";
          dotDir = ".config/zsh";
          shellAliases = {
	    ls = "lsd";
            l = "ls -la";
          };
        };

        xdg.configFile."i3/config".source = "${dotfiles}/.config/i3/config";
        xdg.configFile."i3status/config".source = "${dotfiles}/.config/i3status/config";
        xdg.configFile."mpd/mpd.conf".source = "${dotfiles}/.config/mpd/mpd.conf";
        xdg.configFile."mpv/mpv.conf".source = "${dotfiles}/.config/mpv/mpv.conf";
        xdg.configFile."nvim/init.vim".source = "${dotfiles}/.config/nvim/init.vim";
        xdg.configFile."compton/compton.conf".source = "${dotfiles}/.config/compton/compton.conf";
        xdg.configFile."alacritty/alacritty.yml".source = "${dotfiles}/.config/alacritty/alacritty.yml";
        xdg.configFile."dunst/dunstrc".source = "${dotfiles}/.config/dunst/dunstrc";
        xdg.configFile."emacs/init.el".source = "${dotfiles}/.config/emacs/init.el";
    };
}


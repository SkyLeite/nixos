{ config, pkgs, lib, ... }:

let
  mod = "Mod4";
  my-nur = import /mnt/hdd/projects/nix-repository { };

  nur = import (builtins.fetchTarball
    "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };

  lol-launchhelper = my-nur.lol-launchhelper;
in {
  imports = [
    ./polybar
    ./i3.nix
    ./tmux.nix
    ./neovim.nix
    ./scripts/gui.nix
    ./packages/deadd.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.keyboard = false;
  home.packages = [
    pkgs.nodejs-slim-12_x
    pkgs.python3
    #pkgs.rake
    pkgs.elixir
    pkgs.elixir_ls
    pkgs.yarn
    pkgs.playerctl
    pkgs.simplescreenrecorder
    pkgs.arandr
    pkgs.gimp-with-plugins
    pkgs.picom
    pkgs.virt-manager
    pkgs.xorg.xmodmap
    pkgs.libnotify
    pkgs.yadm
    pkgs.clojure
    pkgs.clojure-lsp
    pkgs.clj-kondo
    pkgs.leiningen
    pkgs.boot
    pkgs.sbcl
    pkgs.lispPackages.quicklisp
    pkgs.tdrop
    pkgs.libreoffice
    pkgs.inotify-tools

    pkgs.htop
    pkgs.tty-clock

    # pkgs.nerdfonts
    pkgs.ytmdesktop
    pkgs.lutris
    pkgs.niv
    pkgs.polymc
    pkgs.discord-canary
    pkgs.jre8
    pkgs.jdk8
    pkgs.mpv
    pkgs.deluge
    pkgs.brasero
    pkgs.sqls
    #pkgs.haskell-language-server
    #pkgs.ghc
    pkgs.gnome.zenity
    pkgs.remmina
    pkgs.pamixer
    pkgs.barrier
    pkgs.obs-studio
    my-nur.ncpamixer-git
    pkgs.dbeaver
    pkgs.strawberry
    pkgs.vscode-with-extensions
    pkgs.sonic-pi

    #lol-launchhelper
  ];

  home.sessionVariables = { EDITOR = "nvim"; };

  programs.git = {
    enable = true;
    userName = "Sky";
    userEmail = "sky@leite.dev";
    extraConfig = { init = { defaultBranch = "main"; }; };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs28NativeComp.overrideAttrs (old: {
      src = pkgs.fetchFromGitHub {
        owner = "emacs-mirror";
        repo = "emacs";
        rev = "41a2def162ee95db6a9ca7e904bbd7feee5e3ccf";
        sha256 = "sha256-lgUMld1iBaBPcOWkmZcmMTWz3wPpcwE91hN/3slZN/E=";
      };
    });
  };
  #programs.firefox.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Source Code Pro";
          style = "Regular";
        };
        bold = {
          family = "Source Code Pro";
          style = "Bold";
        };
        italic = {
          family = "Source Code Pro";
          style = "Italic";
        };
        bold_italic = {
          family = "Source Code Pro";
          style = "Bold Italic";
        };
      };
      window = {
        dynamic_padding = true;
        opacity = 0.95;
        padding = {
          x = 15;
          y = 10;
        };
      };
      #       colors = {
      #         primary = {
      #           background = "0xf1f1f1";
      #           foreground = "0x424242";
      #         };
      #         normal = {
      #           black = "0x212121";
      #           red = "0xc30771";
      #           green = "0x10a778";
      #           yellow = "0xa89c14";
      #           blue = "0x008ec4";
      #           magenta = "0x523c79";
      #           cyan = "0x20a5ba";
      #           white = "0xe0e0e0";
      #         };
      #         bright = {
      #           black = "0x212121";
      #           red = "0xfb007a";
      #           green = "0x5fd7af";
      #           yellow = "0xf3e430";
      #           blue = "0x20bbfc";
      #           magenta = "0x6855de";
      #           cyan = "0x4fb8cc";
      #           white = "0xf1f1f1";
      #         };
      #       };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    plugins = [{
      name = "fzf-tab";
      src = pkgs.fetchFromGitHub {
        owner = "Aloxaf";
        repo = "fzf-tab";
        rev = "e3fae7478fc365a04a06b9972b04766ffed78c1c";
        sha256 = "152vhm7i84ab7xp8bkvxr5axfy6lljiqc0k9vggxpc149knkyh9n";
        fetchSubmodules = true;
      };
    }];
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "fzf" ];
      theme = "alanpeabody";
    };
    initExtra = ''
      path+=("/home/sky/.yarn-packages/bin")

      export PATH
      eval "$(direnv hook zsh)"
      enable-fzf-tab

      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false

      # set descriptions format to enable group support
      zstyle ':completion:*:descriptions' format '[%d]'

      # preview directory's content with exa when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

      # switch group using `,` and `.`
      zstyle ':fzf-tab:*' switch-group ',' '.'

      # complete makefile
      zstyle ':completion:*:*:make:*' tag-order 'targets'
    '';
    shellAliases = { sysyadm = "sudo yadm -Y /etc/yadm"; };
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.autorandr = {
    enable = true;
    profiles = {
      "home" = {
        fingerprint = {
          DisplayPort-1 = "<EDID>";
          DisplayPort-0 = "<EDID>";
        };
        config = {
          DisplayPort-2 = {
            enable = true;
            position = "0x0";
            mode = "1920x1080";
            rate = "143.98";
          };
          DisplayPort-1 = {
            enable = true;
            primary = true;
            position = "1920x0";
            mode = "1920x1080";
            rate = "143.98";
          };
        };
      };
    };
    hooks = {
      postswitch = { "notify-i3" = "${pkgs.i3}/bin/i3-msg restart"; };
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; };
    theme = "Arc-Dark";
    extraConfig = {
      modi = "emoji,drun,ssh";
      kb-primary-paste = "Control+V,Shift+Insert";
      kb-secondary-paste = "Control+v,Insert";
      padding = 18;
      width = 60;
      font = "Noto Sans 12";
    };
  };

  programs.ncmpcpp = {
    enable = true;
    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "J";
        command = [ "select_item" "scroll_down" ];
      }
      {
        key = "K";
        command = [ "select_item" "scroll_up" ];
      }
    ];
  };

  services.random-background = {
    enable = true;
    enableXinerama = true;
    display = "fill";
    imageDirectory = "%h/Pictures/Backgrounds";
    interval = "1h";
  };

  services.unclutter = { enable = true; };
  services.lorri = { enable = true; };

  services.picom = {
    enable = true;
    shadow = true;
    shadowOffsets = [ (-12) (-12) ];
    vSync = false;
    fade = true;
    fadeDelta = 2;
    refreshRate = 144;
  };

  services.dunst = {
    enable = false;

    settings = {
      global = {
        format = "<b>%s</b>\\n\\n%b";
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        geometry = "500x20-30+20";
        follow = "keyboard";
        padding = "16";
        ignore_newline = "no";
        horizontal_padding = "25";
        align = "right";
        word_wrap = "yes";
        markup = "full";
        allow_markup = "yes";
        timeout = 10;
        frame_width = 4;
        frame_color = "#8e24aa";
        corner_radius = 2;
        icon_position = "left";
        show_indicators = true;
        indicate_hidden = false;
      };

      urgency_normal = { background = "#141C21"; };
      urgency_critical = { background = "#FF5250"; };
    };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "sky";
  home.homeDirectory = "/home/sky";

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";
}

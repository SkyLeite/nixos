{ config, pkgs, lib, ... }:
let
  mod = "Mod4";
  leftScreen = "DisplayPort-2";
  rightScreen = "DisplayPort-0";
in {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = mod;
      bars = [ ];

      terminal = "alacritty";
      fonts = {
        names = [ "DejaVu Sans Mono, FontAwesome 6" ];
        style = "Bold Semi-Condensed";
        size = 9.0;
      };

      colors = {
        focused = {
          background = "#390d45";
          border = "#8e24aa";
          text = "#FFFFFF";
          childBorder = "#285577";
          indicator = "#2e9ef4";
        };
      };

      gaps = { inner = 12; };

      keybindings = lib.mkOptionDefault {
        # "${mod}+d" = "exec ${pkgs.albert}/bin/albert toggle";
        "${mod}+d" = "exec rofi -show drun -columns 3 -sidebar-mode";
        "${mod}+s" = "exec rofi -show emoji";
        "${mod}+o" = "exit";
        "${mod}+g" =
          "exec tdrop -am -w 80% -h 45% -x 10% alacritty --class AlacrittyFloating";

        "${mod}+Shift+f" = "kill";
        "${mod}+Shift+y" = "restart";

        "${mod}+h" = "focus left";
        "${mod}+Shift+h" = "move left";
        "${mod}+j" = "focus down";
        "${mod}+Shift+j" = "move down";
        "${mod}+k" = "focus up";
        "${mod}+Shift+k" = "move up";
        "${mod}+l" = "focus right";
        "${mod}+Shift+l" = "move right";

        "${mod}+1" = "workspace 1";
        "${mod}+Shift+1" = "move workspace 1";
        "${mod}+2" = "workspace 2";
        "${mod}+Shift+2" = "move workspace 2";
        "${mod}+3" = "workspace 3";
        "${mod}+Shift+3" = "move workspace 3";
        "${mod}+4" = "workspace 4";
        "${mod}+Shift+4" = "move workspace 4";
        "${mod}+5" = "workspace 5";
        "${mod}+Shift+5" = "move workspace 5";

        "${mod}+q" = "workspace 1:Q";
        "${mod}+Shift+q" = "move workspace 1:Q";
        "${mod}+w" = "workspace 2:W";
        "${mod}+Shift+w" = "move workspace 2:W";
        "${mod}+e" = "workspace 3:E";
        "${mod}+Shift+e" = "move workspace 3:E";
        "${mod}+r" = "workspace 4:R";
        "${mod}+Shift+r" = "move workspace 4:R";
        "${mod}+t" = "workspace 5:T";
        "${mod}+Shift+t" = "move workspace 5:T";

        "${mod}+v" = "split vertical";
        "${mod}+b" = "split horizontal";

        "${mod}+Print" = "exec flameshot full -c";
        "Print" = "exec flameshot gui";

        "XF86AudioRaiseVolume" = "exec pamixer -i 10";
        "XF86AudioLowerVolume" = "exec pamixer -d 10";
        "${mod}+XF86AudioRaiseVolume" = "exec pamixer -i 1";
        "${mod}+XF86AudioLowerVolume" = "exec pamixer -d 1";
        "XF86AudioMute" =
          "exec amixer sset Master toggle && killall -USR1 i3blocks";

        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioNext" = "exec playerctl next";
      };

      workspaceOutputAssign = [
        {
          workspace = "1";
          output = leftScreen;
        }
        {
          workspace = "2";
          output = leftScreen;
        }
        {
          workspace = "3";
          output = leftScreen;
        }
        {
          workspace = "4";
          output = leftScreen;
        }
        {
          workspace = "5";
          output = leftScreen;
        }

        {
          workspace = "1:Q";
          output = rightScreen;
        }
        {
          workspace = "2:W";
          output = rightScreen;
        }
        {
          workspace = "3:E";
          output = rightScreen;
        }
        {
          workspace = "4:R";
          output = rightScreen;
        }
        {
          workspace = "5:T";
          output = rightScreen;
        }
      ];

      startup = [
        {
          command = "systemctl --user restart polybar";
          always = true;
          notification = false;
        }
        { command = "flameshot"; }
        {
          command = "sh ../nixpkgs/screens.sh";
          always = true;
        }
        {
          command = ''
            ${pkgs.pipewire}/bin/pw-loopback --capture-props='node.target="alsa_input.pci-0000_0a_00.4.analog-stereo"'
          '';
        }
      ];

      window.commands = [
        {
          command = "floating enable";
          criteria = { instance = "yakuake"; };
        }

        {
          command = "floating enable";
          criteria = { class = "Pavucontrol"; };
        }

        {
          command = "floating enable";
          criteria = { class = "Blueman-manager"; };
        }

        {
          command = "floating enable";
          criteria = { instance = "AlacrittyFloating"; };
        }

        {
          command = "floating enable";
          criteria = { instance = "origin.exe"; };
        }
      ];
    };
  };
}

{ config, pkgs, lib, ... }:
let mod = "Mod4";
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
        "${mod}+d" = "exec ${pkgs.albert}/bin/albert toggle";
        "${mod}+o" = "exit";
        "${mod}+t" =
          "exec tdrop -am -w 80% -h 45% -x 10% alacritty --class AlacrittyFloating";

        "${mod}+h" = "focus left";
        "${mod}+Shift+h" = "move left";
        "${mod}+j" = "focus down";
        "${mod}+Shift+j" = "move down";
        "${mod}+k" = "focus up";
        "${mod}+Shift+k" = "move up";
        "${mod}+l" = "focus right";
        "${mod}+Shift+l" = "move right";

        "${mod}+v" = "split vertical";
        "${mod}+b" = "split horizontal";

        "${mod}+Print" = "exec flameshot full -c";
        "Print" = "exec flameshot gui";

        "XF86AudioRaiseVolume" =
          "exec pactl set-sink-volume @DEFAULT_SINK@ +10%";
        "XF86AudioLowerVolume" =
          "exec pactl set-sink-volume @DEFAULT_SINK@ -10%";
        "${mod}+XF86AudioRaiseVolume" =
          "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";
        "${mod}+XF86AudioLowerVolume" =
          "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
        "XF86AudioMute" =
          "exec amixer sset Master toggle && killall -USR1 i3blocks";

        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioNext" = "exec playerctl next";
      };

      startup = [
        {
          command = "systemctl --user restart polybar";
          always = true;
          notification = false;
        }
        { command = "albert"; }
        { command = "flameshot"; }
        { command = "yakuake"; }
        {
          command = "sh ../nixpkgs/screens.sh";
          always = true;
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
      ];
    };
  };
}

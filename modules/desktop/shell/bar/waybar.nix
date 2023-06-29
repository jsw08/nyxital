{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];
  shell = config.desktop.shell;
  wm = config.desktop.wm;
  username = config.core.username;

  mkIf = lib.mkIf;
  optStr = lib.optionalString;
  exe = lib.getExe;

  hm = config.home-manager.users.${username};
  laptop = config.core.device == "laptop";
  bluetooth = config.core.bluetooth.enable;
  hyprland = inputs.hyprland.packages.${pkgs.system};
  package =
    if wm == hyprland.hyprland
    then hyprland.waybar-hyprland
    else pkgs.waybar;
  runner = shell.runner;
  terminal = shell.terminal;
  inherit (hm.colorscheme) colors;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  config.home-manager.users.${username}.programs.waybar = mkIf (shell.bar == pkgs.waybar && builtins.elem device compDevices) {
    enable = true;
    package = package;
    systemd.enable = true;
    settings = {
      main = {
        position = "left";
        layer = "top";
        width = 44;
        modules-left = [
          "custom/runner"
          "custom/seperator"
        ];
        modules-center = [
          (optStr (wm == hyprland.hyprland) "wlr/workspaces")
        ];
        modules-right = [
          "tray"
          "pulseaudio"
          (optStr laptop "backlight")
          "network"
          (optStr bluetooth "bluetooth")
          (optStr laptop "battery")
          "clock"
          "custom/power"
        ];

        "custom/runner" = {
          rotate = 0;
          format = " {}";
          on-click = "${exe runner}";
        };
        "custom/seperator" = {
          format = "⌇";
          rotate = 90;
        };
        "wlr/workpaces" = {
          on-click = "activate";
          format = "{icon}";
          persistent_workspaces = {
            "1" = " 1 ";
            "2" = " 2 ";
            "3" = " 3 ";
            "4" = " 4 ";
            "5" = " 5 ";
          };
          format-icons = {
            urgent = "🌕︎";
            hidden = "H";
            "1" = " 1 ";
            "2" = " 2 ";
            "3" = " 3 ";
            "4" = " 4 ";
            "5" = " 5 ";
            "6" = " 6 ";
            "7" = " 7 ";
            "8" = " 8 ";
            "9" = " 9 ";
            "10" = " 10 ";
            "-99" = ".";
            default = "⏺";
          };
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };
        pulseaudio = {
          rotate = 0;
          format = "{icon}";
          format-bluetooth = "{icon}";
          format-muted = "󰖁";
          format-icons = {
            headphone = "󰋋";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          tooltip-format = "{volume}";
          on-click = "${exe pkgs.pulsemixer} --toggle-mute";
          on-click-right = "${exe terminal} ${optStr (terminal == pkgs.alacritty) "-s"} ${exe pkgs.pulsemixer}";
          on-scroll-up = "${exe pkgs.pulsemixer} --change-volume +5";
          on-scroll-down = "${exe pkgs.pulsemixer} --change-volume -5";
        };
        backlight = {
          rotate = 270;
          device = "intel_backlight"; #TODO: Make dependant on cpu
          format = " {icon} ";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
          on-scroll-up = "${exe pkgs.brightnessctl} s 10%+";
          on-scroll-down = "${exe pkgs.brightnessctl} s 10%-";
        };
        bluetooth = {
          rotate = 0;
          format-on = "󰂯";
          format-off = "󰂲";
          format-connected = "󰂱";
          on-click = "${exe terminal} ${optStr (terminal == pkgs.alacritty) "-s"} ${exe pkgs.bluetuith}";
        };
        battery = {
          rotate = 0;
          states = {
            warning = 90;
            critical = 50;
          };
          format = "{icon}";
          format-charging = "{icon}";
          format-icons = ["󰂎" "󰁺" "󰁺" "󰁼" "󰁽" "󰁾" "󰁾" "󰂀" "󰂁" "󰂂" "󱈑"];
          tooltip-format = "{capacity}";
        };
        clock = {
          format = "{:%H\n%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          on-click = "~/.config/hypr/scripts/wp-select.sh dmenu";
        };
        "custom/power" = {
          rotate = 0;
          format = "󰐥";
          on-click = "${exe pkgs.wlogout}";
        };
      };
    };
    style = with colors; ''
      #waybar {
        margin: 8px 0px 8px 6px;
        background: #${base00};
        color: #${base05};
        font-family: "Comic Code Ligatures";
        text-shadow: 0 0 0px black;
      }

      #clock {
        font-size: 18px;
        margin: 12px 4px 0px 4px;
        padding: 4px 2px 4px 2px;
        border-radius: 10px 10px 0 0;
        font-weight: bold;
        background: #${base02};
      }

      #custom-runner {
        margin: 9px 4px 4px 4px;
        padding: 4px 2px 4px 5px;
        font-size: 20px;
        font-weight: 100;
        background: #${base02};
        border-radius: 10px;
        color: #${base0F};
      }

      #custom-power {
        margin: 0px 4px 4px 4px;
        padding: 4px 2px 4px 5px;
        font-size: 20px;
        font-weight: 100;
        background: #${base02};
        border-radius: 0px 0px 10px 10px;
        color: #${base08};
      }

      #custom-sep {
        margin: 4px 0px 8px 2px;
        font-size: 26px;
        font-weight: 100;
      }

      #workspaces {
        margin: 0;
        margin-left: 4px;
        margin-right: 4px;
        padding: 2px 2px 2px 2px;
        border-radius: 10px;
        font-family: "Comic Code Ligatures";
        font-size: 18px;
        text-shadow: 0 0 0px black;
        font-weight: bold;
        background: #${base02};
      }

      #workspaces button {
        padding: 4px 0px 4px 0px;
        font-weight: bold;
        text-shadow: 0 0 0px black;
        color: #${base0D};
      }

      #workspaces button:hover {
        box-shadow: inherit;
        background: transparent;
        border: transparent;
        transition: none;
      }

      #workspaces button.urgent {
        color: #${base09};
      }

      #workspaces button.active {
        padding: 0px;
      }

      #workspaces button.persistent {
        color: #${base04};
      }

      #workspaces button.active label {
        box-shadow: 0 0 0px black;
        font-size: 18px;
        font-weight: bold;
        margin: 9px 3px 9px 3px;
        background-image: linear-gradient(135deg, #${base01}, #${base01});
        background-size: 800% 800%;
        animation: active 120s linear infinite;
        border-radius: 100%;
      }

      @keyframes active {
        0% {
          background-position: 0% 0%;
        }
        100% {
          background-position: 800% 800%;
        }
      }

      #tray {
        margin: 8px 0px 9px 2px;
        opacity: 0.8;
      }

      #pulseaudio {
        margin: 8px 4px 0px 4px;
        padding: 8px 0 0 0;
        font-size: 22px;
        color: #${base0D};
        background: #${base02};
        border-radius: 10px 10px 0 0;
      }

      #backlight {
        margin: 0px 4px 0px 4px;
        font-size: 22px;
        background: #${base02};
        padding: 0 0px 8px 2px;

        color: #${base0A};
      }

      #network {
        margin: 0px 4px 0px 4px;
        font-size: 20px;
        padding: 0 0px 8px 6px;

        color: #${base0C};
        background: #${base02};
      }

      #bluetooth {
        margin: 0px 4px 0px 4px;
        font-size: 22px;

        color: #${base0E};
        background: #${base02};
      }

      #battery {
        margin: 0px 4px 5px 4px;
        padding: 0 0 8px 0;
        font-size: 22px;
        color: #${base0B};
        background: #${base02};
        border-radius: 0px 0px 10px 10px;
      }

    ''; #TODO: wlr workspaces style
  };
}

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.desktop.wm == hyprland;
  username = config.core.username;
  device = config.core.device;
  gpu = config.core.graphics;
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;

  compDevices = ["laptop" "desktop"];
  nvidiaGpu = ["hybrid-in" "nvidia"];
  mkIf = lib.mkIf;
  exe = lib.getExe;
  optStr = lib.optionalString;

  hm = config.home-manager.users.${username};
  inherit (hm.colorscheme) colors;
  pointer = hm.home.pointerCursor;
  shell = config.desktop.shell;
  grimblast = inputs.hyprland-contrib.packages.${pkgs.system}.grimblast;
  bluetooth = config.core.bluetooth.enable;
in {
  imports = [
    inputs.hyprland.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];
  config = mkIf (builtins.elem device compDevices) {
    programs.hyprland = {
      enable = cfg;
      nvidiaPatches = builtins.elem gpu nvidiaGpu;
    };

    home-manager.users.${username} = {
      imports = [inputs.hyprland.homeManagerModules.default];
      wayland.windowManager.hyprland = {
        enable = config.programs.hyprland.enable;
        nvidiaPatches = config.programs.hyprland.nvidiaPatches; # TODO: Rice wlogout
        extraConfig = let
          mpv-paste =
            # TODO: Fix mpv and maybe config it
            pkgs.writeShellScriptBin "mpv-paste" ''
            '';
        in ''
          # Monitors
          monitor = eDP-1,preferred,0x0,1
          monitor = HDMI-A-2,preferred,1920x0,1

          # Cursor and wallpaper
          exec-once = hyprctl setcursor ${pointer.name} ${builtins.toString pointer.size}
          exec-once = ${exe pkgs.swaybg} -i ${../theme/current_wallpaper} -m fill
          exec = ${exe shell.terminal}

          # General/eyecandy config
          general {
            gaps_out = 10
            border_size = 2
            col.active_border = 0xff${colors.base0F}
            col.group_border_active = 0xff${colors.base0B}
            layout = dwindle
          }
          decoration {
            rounding = 10
            blur = yes
            blur_size = 4
            blur_passes = 2
            blur_new_optimizations = on
            active_opacity = 0.95
            inactive_opacity = 0.85
            drop_shadow = yes
            shadow_range = 8
            shadow_render_power = 3
            col.shadow = rgba(1a1a1aee)
          }

          # Animations
          animations {
            enabled = true
            bezier = smoothOut, 0.36, 0, 0.66, -0.56
            bezier = smoothIn, 0.25, 1, 0.5, 1
            bezier = overshot, 0.4,0.8,0.2,1.2

            animation = windows, 1, 4, overshot, slide
            animation = windowsOut, 1, 4, smoothOut, slide
            animation = border,1,10,default
            animation = fade, 1, 10, smoothIn
            animation = fadeDim, 1, 10, smoothIn
            animation = workspaces,1,4,overshot,slidevert
          }

          # Tiling
          dwindle {
            pseudotile = false
            preserve_split = yes
            no_gaps_when_only = false
          }

          # Keybinds
          $M = ALT

          # Logout and shell
          bind = $M, Escape, exec, ${exe pkgs.gtklock}
          bind = $M_SHIFT, Escape, exec, ${exe pkgs.wlogout} -p layer-shell
          bind = $M_SHIFT, Return, exec, firefox #FIXME: ${
            if shell.browser == pkgs.firefox-bin
            then exe hm.programs.firefox.package
            else exe shell.browser
          }
          bind = $M, d, exec, ${exe shell.runner}
          bind = $M, Return, exec, ${exe shell.terminal}

          # Config programs
          bind = $M, a, exec, ${exe shell.terminal} ${exe pkgs.pulsemixer}
          bind = $M, n, exec, ${exe shell.terminal} ${exe pkgs.networkmanager}/bin/nmtui
          ${optStr bluetooth "bind = $M, b, exec, ${exe shell.terminal} ${exe pkgs.bluetuith}"}

          # Program binds
          bind = $M, v, exec, ${exe grimblast} copy area
          bind = $M_SHIFT, d, exec, ${exe pkgs.webcord-vencord}
          bind = $M, w, exec, ${exe mpv-paste}

          # Movement binds
          bind = $M, Q, killactive
          bind = $M, F, fullscreen
          bind = $M, P, togglesplit # dwindle
          bind = $M, SPACE, togglefloating
          bind = $M_SHIFT, E, exit

          bind = $M, G, togglegroup
          bind = $M_SHIFT, G, changegroupactive
          bind = $M, H, movefocus, l
          bind = $M, L, movefocus, r
          bind = $M, K, movefocus, u
          bind = $M, J, movefocus, d

          bind = $M_SHIFT, H, movewindow, l
          bind = $M_SHIFT, L, movewindow, r
          bind = $M_SHIFT, K, movewindow, u
          bind = $M_SHIFT, J, movewindow, d

          bind = $M_CTRL, H, resizeactive, -50 0
          bind = $M_CTRL, L, resizeactive, 50 0
          bind = $M_CTRL, K, resizeactive, 0 -50
          bind = $M_CTRL, J, resizeactive, 0 50

          bind = $M, 1, workspace, 1
          bind = $M, 2, workspace, 2
          bind = $M, 3, workspace, 3
          bind = $M, 4, workspace, 4
          bind = $M, 5, workspace, 5
          bind = $M, 6, workspace, 6
          bind = $M, 7, workspace, 7
          bind = $M, 8, workspace, 8
          bind = $M, 9, workspace, 9
          bind = $M, 0, workspace, 10

          bind = $M_SHIFT, 1, movetoworkspace, 1
          bind = $M_SHIFT, 2, movetoworkspace, 2
          bind = $M_SHIFT, 3, movetoworkspace, 3
          bind = $M_SHIFT, 4, movetoworkspace, 4
          bind = $M_SHIFT, 5, movetoworkspace, 5
          bind = $M_SHIFT, 6, movetoworkspace, 6
          bind = $M_SHIFT, 7, movetoworkspace, 7
          bind = $M_SHIFT, 8, movetoworkspace, 8
          bind = $M_SHIFT, 9, movetoworkspace, 9
          bind = $M_SHIFT, 0, movetoworkspace, 10

          bind = $Ma, mouse_down, workspace, e+1
          bind = $Ma, mouse_up, workspace, e-1
          bindm = $M, mouse:272, movewindow
          bindm = $M, mouse:273, resizewindow
        '';
      };
      home.packages = [
        grimblast
      ];
    };
  };
}

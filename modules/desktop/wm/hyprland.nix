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
        enable = config.programs.hyprland.enable; # TODO: Configure MPV
        nvidiaPatches = config.programs.hyprland.nvidiaPatches; # TODO: Rice wlogout + config to use selected lock
        extraConfig = ''
          # Cursor
          exec-once = hyprctl setcursor ${pointer.name} ${builtins.toString pointer.size}

          # General/eyecandy config
          general {
            border_size = 2
            col = {
              active_border = rgb(${colors.base0F})
              group_border_active = rgb(${colors.base0B})
            }
          }
          decoration = {
            rounding = 10
            active_opacity = 0.95
            inactive_opacity = 0.85

            blur = yes
            blur_size = 4
            blur_passes = 2
            blur_new_optimizations = on

            drop_shadow = 4
            shadow_range = 3
            col.shadow = rgba(292c3cee)
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
          bind $M, Escape, exec ${exe pkgs.gtklock}
          bind $M_SHIFT, Escape, exec ${exe pkgs.wlogout} -p layer-shell
          bind $M_SHIFT, Return, exec ${exe shell.browser}
          bind $M, d, exec ${exe shell.runner}
          bind $M, Return, exec ${exe shell.terminal}

          # Config programs
          bind $M, a, exec ${exe shell.terminal} ${exe pkgs.pulsemixer}
          bind $M, n, exec ${exe shell.terminal} ${exe pkgs.networkmanager}/bin/nmtui
          ${optStr bluetooth "bind $M, b, exec ${exe shell.terminal} ${exe pkgs.bluetuith}"}

          # Program binds
          bind $M v, exec ${exe grimblast} copy area
          bind $M_SHIFT d, exec ${exe pkgs.webcord-vencord}
          bind $M w, exec ${exe pkgs.mpv} $(${pkgs.wl-clipboard}/bin/wl-paste)

          # Movement binds
          bind = $main, Q, killactive
          bind = $main, F, fullscreen
          bind = $main, P, togglesplit # dwindle
          bind = $main, SPACE, togglefloating
          bind = $main SHIFT, E, exit

          bind = $main, G, togglegroup
          bind = $main SHIFT, G, changegroupactive
          bind = $main, H, movefocus, l
          bind = $main, L, movefocus, r
          bind = $main, K, movefocus, u
          bind = $main, J, movefocus, d

          bind = $main SHIFT, H, movewindow, l
          bind = $main SHIFT, L, movewindow, r
          bind = $main SHIFT, K, movewindow, u
          bind = $main SHIFT, J, movewindow, d

          bind = $main CTRL, H, resizeactive, -50 0
          bind = $main CTRL, L, resizeactive, 50 0
          bind = $main CTRL, K, resizeactive, 0 -50
          bind = $main CTRL, J, resizeactive, 0 50

          bind = $main, 1, workspace, 1
          bind = $main, 2, workspace, 2
          bind = $main, 3, workspace, 3
          bind = $main, 4, workspace, 4
          bind = $main, 5, workspace, 5
          bind = $main, 6, workspace, 6
          bind = $main, 7, workspace, 7
          bind = $main, 8, workspace, 8
          bind = $main, 9, workspace, 9
          bind = $main, 0, workspace, 10

          bind = $main SHIFT, 1, movetoworkspace, 1
          bind = $main SHIFT, 2, movetoworkspace, 2
          bind = $main SHIFT, 3, movetoworkspace, 3
          bind = $main SHIFT, 4, movetoworkspace, 4
          bind = $main SHIFT, 5, movetoworkspace, 5
          bind = $main SHIFT, 6, movetoworkspace, 6
          bind = $main SHIFT, 7, movetoworkspace, 7
          bind = $main SHIFT, 8, movetoworkspace, 8
          bind = $main SHIFT, 9, movetoworkspace, 9
          bind = $main SHIFT, 0, movetoworkspace, 10

          bind = $main, mouse_down, workspace, e+1
          bind = $main, mouse_up, workspace, e-1
          bindm = $main, mouse:272, movewindow
          bindm = $main, mouse:273, resizewindow
        '';
      };
      home.packages = [
        grimblast
      ];
    };
  };
}

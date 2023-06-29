{
  config,
  lib,
  inputs,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];
  username = config.core.username;

  mkIf = lib.mkIf;

  inherit (config.home-manager.users.${username}.colorscheme) colors;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  config.home-manager.users.${username} = mkIf (builtins.elem device compDevices) {
    programs.starship = {
      enable = true;
      settings = {
        palettes.nix-color = with colors; {
          base = "#${base00}";
          mantle = "#${base01}";
          surface0 = "#${base02}";
          surface1 = "#${base03}";
          surface2 = "#${base04}";
          text = "#${base05}";
          rosewater = "#${base06}";
          lavender = "#${base07}";
          red = "#${base08}";
          peach = "#${base09}";
          yellow = "#${base0A}";
          green = "#${base0B}";
          teal = "#${base0C}";
          blue = "#${base0D}";
          mauve = "#${base0E}";
          flamingo = "#${base0F}";
        };
      };
    };
  };
}

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];

  mkIf = lib.mkIf;

  inherit (config.colorscheme) colors;
  inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) gtkThemeFromScheme;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  config.home-manager.users.jsw = mkIf (builtins.elem device compDevices) {
    gtk = {
      enable = true;
      theme = {
        name = colors.slug;
        package = gtkThemeFromScheme {scheme = colors;};
      };
      iconTheme = {
        package = pkgs.vimix-icon-theme;
        name = "Vimix-dark";
      };
    };
    qt = {
      enable = true;
      platformTheme = "gtk";
    };
    home.packages = [pkgs.dconf];
  };
}

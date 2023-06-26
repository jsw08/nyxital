{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];
  username = config.core.username;

  mkIf = lib.mkIf;

  hm = config.home-manager.users.${username};
  inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) gtkThemeFromScheme;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  config.home-manager.users.jsw = mkIf (builtins.elem device compDevices) {
    gtk = {
      enable = true;
      theme = {
        name = hm.colorscheme.slug;
        package = gtkThemeFromScheme {scheme = hm.colorscheme;};
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

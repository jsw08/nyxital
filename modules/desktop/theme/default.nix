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
  mkOption = lib.mkOption;
  path = lib.types.path;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./colors.nix
    ./toolkits.nix
  ];
  config.home-manager.users.jsw = mkIf (builtins.elem device compDevices) {
    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };
}

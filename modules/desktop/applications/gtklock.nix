{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];
  username = config.core.username;

  mkIf = lib.mkIf;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  config = mkIf (builtins.elem device compDevices) {
    home-manager.users.${username}.home.packages = [pkgs.gtklock];
    security.pam.services.gtklock = {};
  };
}

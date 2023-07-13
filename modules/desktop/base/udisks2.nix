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
  config = mkIf (builtins.elem device compDevices) {
    services.udisks2.enable = true;
    home-manager.users.${username}.services.udiskie.enable = true;
  };
}

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
  config.home-manager.users.${username} =
    mkIf (builtins.elem device compDevices) {
    };
}

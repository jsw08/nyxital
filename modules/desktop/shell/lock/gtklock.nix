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
  username = config.core.username;

  mkIf = lib.mkIf;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  config = mkIf (shell == 0) {
    home-manager.users.${username} = {
    };
  };
}

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
  config = mkIf (shell == pkgs.firefox && builtins.elem device compDevices) {
    home-manager.users.${username} = {
    };
  };
}

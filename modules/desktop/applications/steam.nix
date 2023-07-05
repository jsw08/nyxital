{
  config,
  lib,
  inputs,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];
  cfg = config.dekstop.steam;

  mkIf = lib.mkIf;
  mkEnableOption = lib.mkEnableOption;

  inherit (config.home-manager.users.${username}.colorscheme) colors;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  options.desktop.steam = mkEnableOption "steam";
  config = mkIf (builtins.elem device compDevices && cfg) {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}

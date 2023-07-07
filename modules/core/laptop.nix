{
  config,
  pkgs,
  lib,
  ...
}: let
  compDevices = ["laptop"];
  device = config.core.device;
  #mkIf = lib.mkIf;
in {
  services.power-profiles-daemon.enable = builtins.elem device compDevices; #TODO: Replace with smt better
  environment.systemPackages = [pkgs.brightnessctl];
}

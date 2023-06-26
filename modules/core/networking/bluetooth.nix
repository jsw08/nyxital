{
  config,
  pkgs,
  lib,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];

  mkIf = lib.mkIf;
in {
  config = mkIf (builtins.elem device compDevices) {
    hardware.bluetooth.enable = true;
    environment.systemPackages = [pkgs.bluetuith]; # Bluetooth tui client.
  };
}

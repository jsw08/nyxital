{
  config,
  pkgs,
  lib,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];

  mkIf = lib.mkIf;
  mkForce = lib.mkForce;
in {
  config = mkIf (builtins.elem device compDevices) {
    sound.enable = mkForce false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    environment.systemPackages = [pkgs.pulsemixer];
  };
}

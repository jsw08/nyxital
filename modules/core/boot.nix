{
  config,
  lib,
  pkgs,
  ...
}: let
  device = config.core.device;
  #server = "server" == device;
  server = true; # FIXME: REMOVE THIS, ONLY FOR DEBUGGING

  mkIf = lib.mkIf;
in {
  config.boot = {
    kernelPackages = pkgs.linuxKernel.rtPackages.linux_rt_6_1;
    plymouth.enable = !server;

    kernelParams = mkIf (!server) ["quiet" "udev.log_level=3"];
    consoleLogLevel = mkIf (!server) 0;
    initrd = {
      verbose = !server;
      systemd.enable = true;
    };
    loader = {
      timeout = 0;
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "max";
        configurationLimit = 10;
      };
    };
  };
}

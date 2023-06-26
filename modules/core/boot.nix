{
  config,
  lib,
  pkgs,
  ...
}: let
  device = config.core.device;
  server = "server" == device;

  mkIf = lib.mkIf;
  mkDefault = lib.mkDefault;

  serverKernel = pkgs.linuxKernel.kernels.linux_hardened;
  kernel = pkgs.linux-rt_latest;
in {
  config.boot = {
    kernelPackages =
      mkDefault
      (
        if server
        then serverKernel
        else kernel
      );
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

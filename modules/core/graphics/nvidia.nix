{
  config,
  pkgs,
  lib,
  ...
}: let
  graphics = config.core.graphics;
  compGpu = ["nvidia" "hybrid-in"];
  mkIf = lib.mkIf;
in {
  config = mkIf (builtins.elem graphics compGpu) {
    services.xserver.videoDrivers = ["nvidia"]; # The driver

    # OpenCL, OpenGL, Vulkan and VAAPI support
    environment.systemPackages = with pkgs; [
      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      libva
      libva-utils
    ];
    hardware = {
      nvidia = {
        modesetting.enable = true;
        prime.offload.enableOffloadCmd = graphics == "hybrid-in";
        powerManagement = {
          enable = true;
          #finegrained = graphics == "hybrid-in";
        };
        nvidiaSettings = false; # useless on wayland, and for my devices in general
      };
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;

        extraPackages = with pkgs; [nvidia-vaapi-driver];
        extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver];
      };
    };
  };
}

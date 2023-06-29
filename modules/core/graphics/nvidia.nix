{
  config,
  pkgs,
  lib,
  ...
}: let
  graphics = config.core.graphics;
  compGpu = ["nvidia" "hybrid-in"];
  pr = pkgs.writeShellScriptBin "pr" ''
    #!/usr/bin/env bash
    export LIBVA_DRIVER_NAME=nvidia
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export WLR_NO_HARDWARE_CURSORS=1

    exec $@
  '';

  mkIf = lib.mkIf;
  optional = lib.optional;
in {
  config = mkIf (builtins.elem graphics compGpu) {
    services.xserver.videoDrivers = ["nvidia"]; # The driver
    environment.variables = mkIf (graphics != "hybrid-in") {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    # OpenCL, OpenGL, Vulkan and VAAPI support
    environment.systemPackages = with pkgs;
      [
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        libva
        libva-utils
      ]
      ++ optional (graphics == "hybrid-in") pr;
    hardware = {
      nvidia = {
        modesetting.enable = true;
        prime.offload = {
          enable = graphics == "hybrid-in";
        };
        powerManagement = {
          enable = true;
          finegrained = graphics == "hybrid-in";
        };
        nvidiaSettings = false; # useless on wayland, and for my devices in general
      };
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        #extraPackages = with pkgs; [nvidia-vaapi-driver]; already specified in the drivers
        #extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver]; https://github.com/NixOS/nixpkgs/blob/nixos-23.05/nixos/modules/hardware/video/nvidia.nix
      };
    };
  };
}

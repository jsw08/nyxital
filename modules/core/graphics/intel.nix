{
  config,
  pkgs,
  lib,
  ...
}: let
  compGpu = ["intel" "hybrid-in"];
  graphics = config.core.graphics;
  mkIf = lib.mkIf;
in {
  config = mkIf (builtins.elem graphics compGpu) {
    # The drivers
    boot.initrd.kernelModules = ["i915"];
    services.xserver.videoDrivers = ["modesetting"];

    nixpkgs.config.packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;}; # Play vids without h.264
    };

    # OpenCL, OpenGL, Vulkan and VAAPI support
    environment.systemPackages = with pkgs; [
      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      libva
      libva-utils
      intel-gpu-tools
    ];

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-compute-runtime
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    environment.variables = mkIf (graphics != "hybrid-in") {
      VDPAU_DRIVER = "va_gl";
    };
  };
}

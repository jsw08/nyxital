{
  config,
  lib,
  ...
}: let
  cpu = config.core.cpu;
  mkIf = lib.mkIf;
in {
  config = mkIf (cpu == "intel") {
    hardware.cpu.intel.updateMicrocode = true;
    boot = {
      kernelModules = ["kvm-intel"];
      kernelParams = ["i915.fastboot=1" "enable_gvt=1"];
    };
  };
}

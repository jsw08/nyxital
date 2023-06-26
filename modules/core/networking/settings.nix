{
  config,
  lib,
  ...
}: let
  mkEnableOption = lib.mkEnableOption;
in {
  options.core.bluetooth.enable = mkEnableOption "bluetooth support.";
}

{lib, ...}: let
  mkOption = lib.mkOption;
  enum = lib.types.enum;
in {
  options.core.cpu = mkOption {
    type = enum ["intel"];
    description = "Enable the cpu microcode, depending on vendor.";
    default = "intel";
    example = "intel";
  };
}

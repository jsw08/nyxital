{lib, ...}: let
  mkOption = lib.mkOption;
  enum = lib.types.enum;
in {
  options.core.graphics = mkOption {
    type = enum ["intel" "nvidia" "hybrid-in" "none"];
    description = "What gpu drivers to use. Hybrid-in stands for hybrid intel nvidia, you'll need to set the prime bus id in your host settings for hybrid configurations.";
    default = "none";
    example = "intel";
  };
}

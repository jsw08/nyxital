{lib, ...}: let
  mkOption = lib.mkOption;
  str = lib.types.str;
  enum = lib.types.enum;
in {
  options.core = {
    username = mkOption {
      type = str;
      description = "Main user's username.";
      default = "jsw";
      example = "jurnw";
    };
    device = {
      type = enum [
        "laptop"
        "desktop"
        "server"
      ];
      description = "This will enable/disable modules depending on host type.";
      default = "desktop";
      example = "laptop";
    };
  };
}

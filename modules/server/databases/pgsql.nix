{
  config,
  pkgs,
  lib,
  ...
}: let
  compDevices = ["server" "laptop"];
  device = config.core.device;

  mkIf = lib.mkIf;
in {
  services.postgresql = mkIf (builtins.elem device compDevices) {
    enable = true;
    dataDir = "/srv/postgresql/${config.services.postgresql.package.psqlSchema}";
  };
}

{
  config,
  pkgs,
  lib,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];

  mkIf = lib.mkIf;
in {
  config = mkIf (builtins.elem device compDevices) {
    security.polkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      # TODO: Disable if DE
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}

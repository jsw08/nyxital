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
  services.home-assistant = mkIf (builtins.elem device compDevices) {
    enable = true;
    openFirewall = true;

    extraComponents = [
      # Components required to complete the onboarding
      "enphase_envoy"
      "p1_monitor"
    ];
    config = {
      http.server_port = 9001;
      homeassistant = {
        unit_system = "metric";
        time_zone = "Europe/Amsterdam";
        temperature_unit = "C";
        longitude = 52.100833; # Centerpoint of the netherlands, not my actual address kek
        latitude = 5.646111;
      };
      default_config = {};
    }; # TODO: Make the config declerative.
    configDir = "/srv/homeassistant";
  };
}

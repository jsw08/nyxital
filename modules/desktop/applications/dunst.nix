{
  config,
  lib,
  inputs,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];
  username = config.core.username;

  mkIf = lib.mkIf;

  inherit (config.home-manager.users.${username}.colorscheme) colors;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  config.home-manager.users.${username}.services.dunst = mkIf (builtins.elem device compDevices) {
    enable = true;
    settings = with colors; {
      global = {
        frame_color = "#${base0D}";
        separator_color = "frame";
      };
      urgency_low = {
        background = "#${base00}";
        foreground = "#${base05}";
      };
      urgency_normal = {
        background = "#${base00}";
        foreground = "#${base05}";
      };
      urgency_critical = {
        background = "#${base00}";
        foreground = "#${base05}";
        frame_color = "#${base09}";
      };
    };
  };
}

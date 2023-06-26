{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];
  shell = config.desktop.shell;
  username = config.core.username;
  wm = config.dekstop.wm;
  anyrun = inputs.anyrun.packages.${pkgs.system}.anyrun;

  mkIf = lib.mkIf;
  exe = lib.getExe;
in {
  config = mkIf (shell.greeter == anyrun && builtins.elem device compDevices) {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = username;
          command = "${exe pkgs.cage} ${exe pkgs.greetd.gtkgreet} ${exe wm}";
        };
        inital_settings = {
          user = username;
          command = "${exe wm}";
        };
      };
    };
  };
}

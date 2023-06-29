{
  config,
  lib,
  pkgs,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];
  shell = config.desktop.shell;
  username = config.core.username;
  wm = config.desktop.wm;

  mkIf = lib.mkIf;
  exe = lib.getExe;
in {
  config = mkIf (shell.greeter == pkgs.greetd.tuigreet && builtins.elem device compDevices) {
    services.greetd = {
      enable = true;
      vt = 2;
      settings = {
        default_session = {
          command = "${exe pkgs.greetd.tuigreet} --time --remember --user-menu --asterisks -c ${exe wm}";
          user = "greeter";
        };
        initial_session = {
          command = "${exe wm}";
          user = "${username}";
        };
      };
    };
  };
}

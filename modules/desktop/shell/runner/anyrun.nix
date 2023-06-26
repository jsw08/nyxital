{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];
  shell = config.desktop.shell;
  username = config.core.username;

  mkIf = lib.mkIf;
  anyrun = inputs.anyrun.packages.${pkgs.system}.anyrun;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager.users.${username} = mkIf (shell.runner == anyrun && builtins.elem device compDevices) {
    imports = [inputs.anyrun.homeManagerModules.default];
    programs.anyrun = {
      enable = true;
      config = {
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          applications
          rink
          shell
          symbols
          translate
        ];
        width = {fraction = 0.3;};
        position = "top";
        verticalOffset = {absolute = 0;};
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = false;
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = null;
      };
      extraCss = ''
      '';
    };
  };
}

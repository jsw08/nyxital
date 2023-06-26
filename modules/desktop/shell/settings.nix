{
  pkgs,
  lib,
  inputs,
  ...
}: let
  mkOption = lib.mkOption;
  types = lib.types;
  anyrun = inputs.anyrun.packages.${pkgs.system}.anyrun;
in {
  options.desktop.shell = {
    bar = mkOption {
      type = types.enum [pkgs.waybar];
      description = "What bar to install";
      default = pkgs.waybar;
      example = pkgs.waybar;
    };
    browser = mkOption {
      type = types.enum [pkgs.firefox-bin];
      description = "What browser to install";
      default = pkgs.firefox-bin;
      example = pkgs.firefox-bin;
    };
    greeter = mkOption {
      type = types.enum [pkgs.greetd.gtkgreet];
      description = "What greeter to install";
      default = pkgs.greetd.gtkgreet;
      example = pkgs.greetd.gtkgreet;
    };
    lock = mkOption {
      type = types.enum [pkgs.gtklock];
      description = "What locker to install";
      default = pkgs.gtklock;
      example = pkgs.gtklock;
    };
    notif = mkOption {
      type = types.enum [pkgs.dunst];
      description = "What notify service to install";
      default = pkgs.dunst;
      example = pkgs.dunst;
    };
    runner = mkOption {
      type = types.enum [anyrun];
      description = "What application runner to install";
      default = anyrun;
      example = anyrun;
    };
    terminal = mkOption {
      type = types.enum [pkgs.kitty];
      description = "What terminal to install";
      default = pkgs.kitty;
      example = pkgs.kitty;
    };
  };
}

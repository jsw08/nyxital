{
  lib,
  inputs,
  pkgs,
  ...
}: let
  mkOption = lib.mkOption;
  mkEnableOption = lib.mkEnableOption;

  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
  enum = lib.enum;
  boolean = lib.boolean;
in {
  options.desktop.wm = mkOption {
    type = enum [hyprland];
    default = hyprland;
    description = "What windowmanager/desktop-environment to install. Desktop environments will disable all shell components, excluding browser and terminal.";
    example = hyprland;
  };
}

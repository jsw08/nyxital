{
  config,
  lib,
  inputs,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];

  mkIf = lib.mkIf;

  catpuccin-frappe = (import ./colorschemes/catpuccin-frappe.nix).colorscheme;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  config.home-manager.users.jsw = mkIf (builtins.elem device compDevices) {
    imports = [inputs.nix-colors.homeManagerModule];
    config.colorscheme = catpuccin-frappe;
  };
}

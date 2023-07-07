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
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager.users.${username} = mkIf (builtins.elem device compDevices) {
    programs.gh = {
      enable = true;
      enableGitCredentialHelper = true;
    };
    xdg.configFile."gh/hosts.yml".source = config.age.secrets."gh".path;
  };
}

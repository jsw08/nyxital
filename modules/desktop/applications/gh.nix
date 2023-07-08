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
  mkOut = config.home-manager.users.${username}.lib.file.mkOutOfStoreSymlink;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager.users.${username} = mkIf (builtins.elem device compDevices) {
    programs.gh = {
      enable = true;
      enableGitCredentialHelper = true;
    };
    home.file.".config/gh/hosts.yml".source = mkOut config.age.secrets."gh".path;
  };
}

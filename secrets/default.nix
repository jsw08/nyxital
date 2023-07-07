{
  config,
  lib,
  inputs,
  ...
}: let
  mkDefault = lib.mkDefault;
in {
  imports = [inputs.agenix.nixosModules.default];

  services.openssh = {
    enable = true;
    openFirewall = mkDefault (config.core.device == "server");
  };
  age.secrets.jswPass.file = ./jswPass.age;
  age.secrets.gh.file = ./gh.age;
  age.secrets.nextcloud = {
    file = ./nextcloud.age;
    owner = "nextcloud";
  };
}

{inputs, ...}: {
  imports = [inputs.agenix.nixosModules.default];

  services.openssh = {
    enable = true;
    openFirewall = false;
  };
  age.secrets.jswPass.file = ./jswPass.age;
}

{self, ...}: let
  inputs = self.inputs;

  modules = ../modules;
  secrets = ../secrets;

  shared = [
    modules
    secrets
  ];
in {
  jsw-laptop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "jsw-laptop";}
        ./jsw-laptop
      ]
      ++ shared;
    specialArgs = {inherit inputs self;};
  };
  jsw-vm = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "jsw-vm";}
        ./jsw-vm
      ]
      ++ shared;
    specialArgs = {inherit inputs self;};
  };
}

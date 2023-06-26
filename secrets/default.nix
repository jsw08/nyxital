{inputs, ...}: {
  imports = [inputs.agenix.nixosModules.default];

  age.secrets.jswPass.file = "./jswPass.age";
}

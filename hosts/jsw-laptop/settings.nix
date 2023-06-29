_: {
  core = {
    device = "laptop";
    username = "jsw";
    bluetooth.enable = true;
    graphics = "hybrid-in";
    cpu = "intel";
  };
  #desktop.shell.greeter = "none";
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}

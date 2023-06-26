_: {
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.networkmanager = {
    enable = true;
    appendNameservers = ["1.1.1.1" "1.0.0.1"];
  };
}

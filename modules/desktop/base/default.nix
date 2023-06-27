_: {
  imports = [
    ./pipewire.nix
    ./polkit.nix
    ./fonts.nix
  ];
  services.xserver.desktopManager.xterm.enable = false;
}

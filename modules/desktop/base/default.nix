_: {
  imports = [
    ./pipewire.nix
    ./polkit.nix
    ./fonts.nix
  ];
  services = {
    #TODO: Migrate udisks
    xserver.desktopManager.xterm.enable = false;
    udisks2.enable = true;
    gvfs.enable = true;
  };
}

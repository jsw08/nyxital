_: {
  imports = [
    ./pipewire.nix
    ./polkit.nix
    ./fonts.nix
    ./udisks2.nix
  ];
  services = {
    #TODO: Migrate udisks
    xserver.desktopManager.xterm.enable = false;
    gvfs.enable = true;
  };
}

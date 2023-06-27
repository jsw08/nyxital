{
  lib,
  inputs,
  pkgs,
  ...
}: let
  mkDefault = lib.mkDefault;
  mappedRegistry = lib.mapAttrs (_: v: {flake = v;}) inputs;
in {
  # TODO: Add nix-super
  # faster rebuilding
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
  };

  nixpkgs = {
    config = {
      allowUnfree = true; # Really annoying without
      allowBroken = false;
    };
    #overlays = []; TODO: rust
  };

  system = {
    autoUpgrade = {
      enable = true;
      flake = "git+https://git.sr.ht/~jsw08/dotfiles";
    };
    stateVersion = mkDefault "23.05";
  };

  nix = {
    registry = mappedRegistry // {default = mappedRegistry.nixpkgs;}; # Make the `nix` command use the same nixpkgs as this flake.
    gc = {
      automatic = true;
      dates = "weekly";
    };
    settings = {
      flake-registry = "/etc/nix/registry.json"; # specify the path to the nix registry
      min-free = "${toString (5 * 1024 * 1024 * 1024)}"; # Free up 20gb when only 5gb left
      max-free = "${toString (20 * 1024 * 1024 * 1024)}";
      auto-optimise-store = true; # automatically optimise symlinks
      allowed-users = ["@wheel" "nix-builder"]; # Trust sudo users
      trusted-users = ["@wheel" "nix-builder"];
      max-jobs = "auto"; # let the system decide the number of max jobs
      sandbox = true; # build inside sandboxed environments
      system-features = ["nixos-tests" "kvm" "recursive-nix" "big-parallel"];
      keep-going = true; # continue building derivations if one fails
      log-lines = 30; # show more log lines for failed builds
      extra-experimental-features = [
        # enable new nix command and flakes and also "unintended" recursion as well as content addresssed nix
        "flakes"
        "nix-command"
        "recursive-nix"
        "ca-derivations"
      ];

      warn-dirty = false;
      http-connections = 0; # No limit on parallel fetching from binary cache

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      # use binary cache, its not gentoo
      # external builders can also pick up those substituters
      builders-use-substitutes = true;
      substituters = [
        "https://cache.nixos.org" # funny binary cache
        "https://nixpkgs-wayland.cachix.org" # automated builds of *some* wayland packages
        "https://nix-community.cachix.org" # nix-community cache
        "https://hyprland.cachix.org" # hyprland
        "https://nix-gaming.cachix.org" # nix-gaming
        "https://nixpkgs-unfree.cachix.org" # unfree-package cache
        "https://numtide.cachix.org" # another unfree package cache
        "https://anyrun.cachix.org" # anyrun
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
    };
  };
  environment.systemPackages = [pkgs.git]; # Flakes dependancy
}

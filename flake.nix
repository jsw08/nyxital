{
  description = "Jsw's dotfiles";
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations = import ./hosts inputs;
  };
  inputs = {
    # Nix repos
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland & Hyprland Contrib repos
    hyprland = {
      url = "github:hyprwm/Hyprland";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    # Apps
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-colors.url = "github:misterio77/nix-colors";
    anyrun = {
      url = "github:Kirottu/anyrun";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    arrpc.url = "github:notashelf/arrpc-flake";
    nvim-flake = {
      url = "github:NotAShelf/neovim-flake/release/v0.4";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    #ironbar = {
    #url = "github:JakeStanger/ironbar";
    #inputs.nixpkgs.follows = "nixpkgs";
    #};
  };
}

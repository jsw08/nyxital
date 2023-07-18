{
  config,
  pkgs,
  inputs,
  ...
}: let
  username = config.core.username;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.users = {
    root = {
      initialPassword = "changeme";
      passwordFile = config.age.secrets."${username}Pass".path; # Requires a secret named <yourUsername>Pass. You can generate a password file using `mkpasswd -m sha-512` and then encrypt it with agenix.
    };
    ${username} = {
      initialPassword = "changeme";
      passwordFile = config.age.secrets."${username}Pass".path; # Requires a secret named <yourUsername>Pass. You can generate a password file using `mkpasswd -m sha-512` and then encrypt it with agenix.

      isNormalUser = true;
      home = "/home/${username}/";
      description = "${username}";
      extraGroups = ["wheel" "networkmanager" "dialout"];
      shell = pkgs.fish; #TODO: Replace with currently selected shell
    };
  };
  programs.fish.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };
    users.${username} = {
      home.username = "${username}";
      home.homeDirectory = "/home/${username}/";
      home.stateVersion = config.system.stateVersion;
      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
        };
      };

      programs.home-manager.enable = true; # allows it to manage itself?
    };
  };
}

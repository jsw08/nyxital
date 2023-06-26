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
      initialPassword = "changeme"; #TODO: Agenix
      passwordFile = config.age.secrets."${username}Pass".path; # Requires a secret named <yourUsername>Pass. You can generate a password file using `mkpasswd -m sha-512` and then encrypt it with agenix.

      isNormalUser = true;
      home = "/home/${username}/";
      description = "${username}";
      extraGroups = ["wheel" "networkmanager"];
      shell = pkgs.fish; #TODO: Replace with currently selected shell
    };
  };
  programs.fish.enable = true;

  home-manager = {
    osConfig,
    inputs,
    ...
  }: {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };
    users.${username} = {
      home.username = "${username}";
      home.homeDirectory = "/home/${username}/";
      home.stateVersion = osConfig.system.stateVersion;
      home.sessionVariables = {
        #for some raeson not defined automatically smh
        XDG_CONFIG_HOME = "/home/${username}/.config";
        XDG_CACHE_HOME = "/home/${username}/.cache";
        XDG_DATA_HOME = "/home/${username}/.local/share";
        XDG_STATE_HOME = "/home/${username}/.local/state";
      };

      programs.home-manager.enable = true; # allows it to manage itself?
    };
  };
}

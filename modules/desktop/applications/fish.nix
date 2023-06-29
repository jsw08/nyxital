{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];
  username = config.core.username;

  mkIf = lib.mkIf;

  exe = lib.getExe;
  git = exe pkgs.git;
  exa = exe pkgs.exa;

  inherit (config.home-manager.users.${username}.colorscheme) colors;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  config.home-manager.users.${username}.programs = mkIf (builtins.elem device compDevices) {
    fish = {
      enable = true;
      shellAliases = {
        add = "${git} add .";
        commit = "${git} commit -m ";
        push = "${git} push";
        pull = "${git} pull";
        la = "${exa} -l --icons --header";
        ls = "${exa} --icons";
      };
      functions = {
        shell = "nix shell nixpkgs#$argv";
        run = "nix run nixpkgs#$argv";
      };
      interactiveShellInit = with colors; ''
        ${exe pkgs.pfetch}

        set fish_color_normal ${base05}
        set fish_color_command ${base0D}
        set fish_color_param ${base0F}
        set fish_color_keyword ${base08}
        set fish_color_quote ${base0B}
        set fish_color_redirection ${base0F}
        set fish_color_end ${base09}
        set fish_color_comment ${base04}
        set fish_color_error ${base08}
        set fish_color_gray ${base03}
        set fish_color_selection --background=${base02}
        set fish_color_search_match --background=${base02}
        set fish_color_option ${base0B}
        set fish_color_operator ${base0F}
        set fish_color_escape ${base08}
        set fish_color_autosuggestion ${base03}
        set fish_color_cancel ${base08}
        set fish_color_cwd ${base0A}
        set fish_color_user ${base0C}
        set fish_color_host ${base0D}
        set fish_color_host_remote ${base0B}
        set fish_color_status ${base08}
        set fish_pager_color_progress ${base03}
        set fish_pager_color_prefix ${base0F}
        set fish_pager_color_completion ${base05}
        set fish_pager_color_description ${base03}

        set fish_greeting
        fish_vi_key_bindings
      '';
    };
    starship.enableFishIntegration = true;
    kitty.shellIntegration.enableFishIntegration = true;
  };
}

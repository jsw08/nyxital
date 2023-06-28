{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  device = config.core.device;
  compDevices = ["laptop" "desktop"];
  username = config.core.username;

  mkIf = lib.mkIf;

  hm = config.home-manager.users.${username}; 
  inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) vimThemeFromScheme;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.users.${username} = mkIf (builtins.elem device compDevices) {
    imports = [inputs.nvim-flake.homeManagerModules.default];
    programs.neovim-flake = {
      enable = true;
      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;
          wordWrap = true;
        };
        vim.autopairs.enable = true;
        vim.autocomplete = {
          enable = true;
          type = "nvim-cmp";
        };
        vim.git = {
          enable = true;
          gitsigns.enable = true;
        };
        vim.projects = {
          project-nvim.enable = true;
        };
        vim.notes = {
          todo-comments.enable = true;
        };
        vim.terminal = {
          toggleterm = {
            enable = true;
          };
        };
        vim.utility = {
          ccc.enable = true;
          vim-wakatime.enable = true;
          surround.enable = true;
          motion = {
            leap.enable = false; #FIXME: not compatible with nvim-surround
          };
        };
        vim.comments = {
          comment-nvim.enable = true;
        };

        vim.lsp = {
          formatOnSave = true;
          lightbulb.enable = true;
          nvimCodeActionMenu.enable = true;
        };
        vim.languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          nix.enable = true;
          html.enable = true;
          rust = {
            enable = true;
            crates.enable = true;
          };
          ts.enable = true;
          svelte.enable = true;
          python.enable = true;
        };
        vim.treesitter = {
          enable = true;
          autotagHtml = true;
          context.enable = true;
          fold = true;
        };

        vim.visuals = {
          enable = true;
          nvimWebDevicons.enable = true;
          scrollBar.enable = true;
          smoothScroll.enable = true;
          cellularAutomaton.enable = true;
          fidget-nvim.enable = true;
          indentBlankline = {
            enable = true;
            fillChar = null;
            eolChar = null;
            showCurrContext = true;
          };
          cursorWordline = {
            enable = true;
            lineTimeout = 0;
          };
        };
        vim.dashboard = {
          alpha.enable = true;
        };
        vim.ui = {
          noice.enable = true;
          colorizer.enable = true;
          illuminate.enable = true;
          smartcolumn = {
            enable = false; # TODO: use me
            #columnAt.languages = {
            #  # this is a freeform module, it's `buftype = int;` for configuring column position
            #  nix = 110;
            #};
          };
        };
        vim.telescope.enable = true;

        vim.optPlugins = [(vimThemeFromScheme {scheme = hm.colorscheme;})];
        vim.luaConfigRC.colorscheme = inputs.nvim-flake.lib.nvim.dag.entryAnywhere ''
          vim.cmd.colorscheme('nix-${hm.colorscheme.slug}')
        '';

        vim.filetree = {
          nvimTreeLua = {
            enable = true;
            renderer = {
              rootFolderLabel = null;
            };
            view = {
              width = 25;
              cursorline = false;
            };
          };
        };
        vim.statusline = {
          lualine.enable = true;
        };
        vim.tabline = {
          nvimBufferline = {
            enable = true;
            mappings = {
              closeCurrent = "<leader>q";
              cycleNext = "L";
              cyclePrevious = "H";
            };
          };
        };

        vim.binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        vim.presence = {
          presence-nvim = {
            enable = true;
            auto_update = true;
            image_text = "Vimming in a flaky neo environment.";
            client_id = "793271441293967371";
            main_image = "neovim";
            rich_presence = {
              editing_text = "Fucking up %s";
            };
          };
        };
      };
    };
  };
}

# Nixvim - Neovim configured through Nix (home-manager integration)
{ config, lib, ... }:
{
  imports = [
    ./colorscheme.nix
    ./keymaps.nix
    ./plugins
  ];

  options.development.nixvim = {
    enable = lib.mkEnableOption "Enables nixvim.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.nixvim.package;
      description = "The nixvim package to use.";
    };
  };

  config = lib.mkIf config.development.nixvim.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      opts = {
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
        expandtab = true;
        list = true;
        laststatus = 3;
        foldlevel = 99;
        clipboard = "unnamedplus";
        updatetime = 500;
      };
      clipboard.providers.xclip.enable = true;
      extraConfigLuaPre = with config.scheme.withHashtag; ''
        vim.opt.fillchars:append({ eob = " " })
        vim.opt.listchars = { tab = "  ", trail = "_", lead = " " }
        vim.api.nvim_set_hl(0, "WinSeparator", {
          fg = "${base01}",
          bg = "${base00}",
        })
        vim.api.nvim_set_hl(0, 'NotifyERRORBorder', { fg = '${base08}' })
        vim.api.nvim_set_hl(0, 'NotifyWARNBorder', { fg = '${base09}' })
        vim.api.nvim_set_hl(0, 'NotifyINFOBorder', { fg = '${base0B}' })
        vim.api.nvim_set_hl(0, 'NotifyDEBUGBorder', { fg = '${base03}' })
        vim.api.nvim_set_hl(0, 'NotifyTRACEBorder', { fg = '${base0E}' })

        vim.api.nvim_set_hl(0, 'NotifyERRORIcon', { fg = '${base08}' })
        vim.api.nvim_set_hl(0, 'NotifyWARNIcon', { fg = '${base09}' })
        vim.api.nvim_set_hl(0, 'NotifyINFOIcon', { fg = '${base0B}' })
        vim.api.nvim_set_hl(0, 'NotifyDEBUGIcon', { fg = '${base03}' })
        vim.api.nvim_set_hl(0, 'NotifyTRACEIcon', { fg = '${base0E}' })

        vim.api.nvim_set_hl(0, 'NotifyERRORTitle', { fg = '${base08}' })
        vim.api.nvim_set_hl(0, 'NotifyWARNTitle', { fg = '${base09}' })
        vim.api.nvim_set_hl(0, 'NotifyINFOTitle', { fg = '${base0B}' })
        vim.api.nvim_set_hl(0, 'NotifyDEBUGTitle', { fg = '${base03}' })
        vim.api.nvim_set_hl(0, 'NotifyTRACETitle', { fg = '${base0E}' })

        vim.api.nvim_set_hl(0, 'NotifyERRORBody', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'NotifyWARNBody', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'NotifyINFOBody', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'NotifyDEBUGBody', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'NotifyTRACEBody', { link = 'Normal' })

        vim.api.nvim_create_autocmd({ "FileType" }, {
          pattern = { "yaml", "yml" },
          callback = function()
            vim.opt_local.expandtab = true
            vim.opt_local.shiftwidth = 2
            vim.opt_local.softtabstop = 2
            vim.opt_local.tabstop = 2
          end,
        })
      '';
      performance = {
        byteCompileLua.enable = true;
        combinePlugins.enable = true;
      };

      diagnostic = {
        settings = {
          virtual_text = false;
          signs = true;
          underline = true;
          update_in_insert = false;
          float = {
            border = "rounded";
            source = true;
            header = "";
            prefix = "";
          };
        };
      };

      autoCmd = [
        {
          event = [ "CursorHold" ];
          pattern = "*";
          callback.__raw = ''
            function()
              vim.diagnostic.open_float(nil, { focus = false })
            end
          '';
        }
      ];
    };
  };
}

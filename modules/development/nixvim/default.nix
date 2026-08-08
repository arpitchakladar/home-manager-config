# Neovim configured through Nix
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

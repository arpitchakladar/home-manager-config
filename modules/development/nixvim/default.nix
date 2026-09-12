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
      default = config.programs.nixvim.build.package;
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
        wrap = true;
        linebreak = true;
        breakindent = true;
        showbreak = "↳";
        list = true;
        laststatus = 3;
        foldlevel = 99;
        clipboard = "unnamedplus";
        updatetime = 500;
        fillchars = "eob: ";
        listchars = "tab:  ,trail:_,lead: ";
      };
      globals.mapleader = " ";
      clipboard.providers.xclip.enable = true;

      highlight = with config.scheme.withHashtag; {
        WinSeparator = {
          fg = base01;
          bg = base00;
        };
      };

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
        {
          event = [ "FileType" ];
          pattern = [
            "yaml"
            "yml"
          ];
          command = "setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2";
        }
      ];
    };
  };
}

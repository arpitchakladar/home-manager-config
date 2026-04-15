{ config, lib, ... }:

# LSP - Language Server Protocol configuration (nvim-lspconfig)
{
  config.programs.nixvim = lib.mkIf config.tools.nixvim.enable {
    plugins.lsp = {
      enable = true;
      inlayHints = true;
      keymaps.lspBuf = {
        K = "hover";
        gD = "references";
        gd = "definition";
        gi = "implementation";
        gt = "type_definition";
      };
      servers = {
        nil_ls = {
          enable = true;
        };
        lua_ls = {
          enable = true;
          package = null;
        };
        nixd = {
          enable = true;
          package = null;
        };
        pyright = {
          enable = true;
          package = null;
        };
        ts_ls = {
          enable = true;
          package = null;
        };
        clangd = {
          enable = true;
          package = null;
        };
        jsonls = {
          enable = true;
          package = null;
        };
        yamlls = {
          enable = true;
          package = null;
        };
        bash-language-server = {
          enable = true;
          package = null;
        };
        gopls = {
          enable = true;
          package = null;
        };
      };
    };

    diagnostic = {
      settings = {
        virtual_text = false;
        signs = true;
        underline = true;
        update_in_insert = false;
        float = {
          border = "rounded";
          source = true; # Show which LSP the diagnostic is from
          header = "";
          prefix = "";
        };
      };
    };

    # Show diagnostics float on cursor hold
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

    # How long before CursorHold fires (in ms)
    opts.updatetime = 500;
  };
}

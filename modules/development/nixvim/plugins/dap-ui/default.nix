# A UI for nvim-dap.
{ config, lib, ... }:
let
  cfg = config.development.nixvim;
in
{
  config.programs.nixvim = lib.mkIf cfg.enable {
    plugins.dap-ui = {
      enable = true;
    };

    keymaps = [
      # dap-ui controls
      {
        mode = "n";
        key = "<leader>du";
        action = "<cmd>lua require('dapui').toggle()<CR>";
        options.desc = "Debug: Toggle UI";
      }
      {
        mode = "n";
        key = "<leader>de";
        action = "<cmd>lua require('dapui').eval()<CR>";
        options.desc = "Debug: Eval Expression Under Cursor";
      }
    ];

    # Auto open/close dap-ui with the debug session lifecycle
    extraConfigLua = builtins.readFile ./dap-ui.lua;
  };
}

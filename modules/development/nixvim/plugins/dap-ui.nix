# A UI for nvim-dap.
{ config, lib, ... }:
{
  config.programs.nixvim = lib.mkIf config.development.nixvim.enable {
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
  };
}

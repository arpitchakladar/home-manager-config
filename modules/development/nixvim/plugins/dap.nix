# Debug Adapter Protocol client implementation for Neovim.
{ config, lib, ... }:
{
  config.programs.nixvim = lib.mkIf config.development.nixvim.enable {
    plugins.dap = {
      enable = true;
    };

    keymaps = [
      # Core DAP controls
      {
        mode = "n";
        key = "<leader>dc";
        action = "<cmd>lua require('dap').continue()<CR>";
        options.desc = "Debug: Continue";
      }
      {
        mode = "n";
        key = "<leader>di";
        action = "<cmd>lua require('dap').step_into()<CR>";
        options.desc = "Debug: Step Into";
      }
      {
        mode = "n";
        key = "<leader>do";
        action = "<cmd>lua require('dap').step_over()<CR>";
        options.desc = "Debug: Step Over";
      }
      {
        mode = "n";
        key = "<leader>dO";
        action = "<cmd>lua require('dap').step_out()<CR>";
        options.desc = "Debug: Step Out";
      }
      {
        mode = "n";
        key = "<leader>db";
        action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
        options.desc = "Debug: Toggle Breakpoint";
      }
      {
        mode = "n";
        key = "<leader>dB";
        action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
        options.desc = "Debug: Conditional Breakpoint";
      }
      {
        mode = "n";
        key = "<leader>dl";
        action = "<cmd>lua require('dap').run_last()<CR>";
        options.desc = "Debug: Run Last";
      }
      {
        mode = "n";
        key = "<leader>dt";
        action = "<cmd>lua require('dap').terminate()<CR>";
        options.desc = "Debug: Terminate";
      }
      {
        mode = "n";
        key = "<leader>dr";
        action = "<cmd>lua require('dap').repl.toggle()<CR>";
        options.desc = "Debug: Toggle REPL";
      }
    ];

    # Auto open/close dap-ui with the debug session lifecycle
    extraConfigLua = ''
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    '';
  };
}

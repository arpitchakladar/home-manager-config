{ config, lib, ... }:

# Keymaps - Keyboard shortcut configuration for nixvim
{
  config.programs.nixvim.keymaps = lib.mkIf config.programs.nixvim.enable [
    {
      key = "<c-h>";
      action = "<c-w>h";
      options.desc = "Move to left window";
    }
    {
      key = "<c-w>";
      action = "<c-w>j";
      options.desc = "Move to bottom window";
    }
    {
      key = "<c-k>";
      action = "<c-w>k";
      options.desc = "Move to top window";
    }
    {
      key = "<c-l>";
      action = "<c-w>l";
      options.desc = "Move to right window";
    }
    {
      key = "<c-n>";
      action = "<cmd>NvimTreeToggle<cr>";
      mode = [
        "n"
        "i"
      ];
      options.desc = "Toggle file explorer";
    }
    {
      key = "<c-c>";
      action = "<cmd>NotificationsClear<cr>";
      options.desc = "Clear notifications";
    }
  ];
}

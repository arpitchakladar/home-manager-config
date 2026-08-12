# Keyboard shortcut configuration for nixvim
{ config, lib, ... }:
{
  config.programs.nixvim.keymaps = lib.mkIf config.development.nixvim.enable [
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
      key = "<c-d>";
      action = "<c-d>zz";
      options.desc = "Scroll half page down and center";
    }
    {
      key = "<c-u>";
      action = "<c-u>zz";
      options.desc = "Scroll half page up and center";
    }
    {
      key = "<c-f>";
      action = "<c-f>zz";
      options.desc = "Scroll full page down and center";
    }
    {
      key = "<c-b>";
      action = "<c-b>zz";
      options.desc = "Scroll full page up and center";
    }
  ];
}

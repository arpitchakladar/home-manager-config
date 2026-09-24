# Keyboard shortcut configuration for nixvim
{ config, lib, ... }:
let
  cfg = config.development.nixvim;
in
{
  config.programs.nixvim.keymaps = lib.mkIf cfg.enable [
    # set the <space> key to nop for normal and visual modes as we are tyring
    # to use it as our <leader>
    {
      mode = [
        "n"
        "v"
      ];
      key = "<space>";
      action = "<nop>";
      options.desc = "Disable leader delay";
    }
    # window navigation
    {
      key = "<c-h>";
      action = "<c-w>h";
      options.desc = "Move to left window";
    }
    {
      key = "<c-j>";
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
    # window resizing
    {
      key = "<C-=>";
      action = "<c-w>+";
      options.desc = "Increase window height";
    }
    {
      key = "<C-->";
      action = "<c-w>-";
      options.desc = "Decrease window height";
    }
    {
      key = "<C-.>";
      action = "<c-w>>";
      options.desc = "Increase window height";
    }
    {
      key = "<C-,>";
      action = "<c-w><";
      options.desc = "Decrease window height";
    }
    # scrolling
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

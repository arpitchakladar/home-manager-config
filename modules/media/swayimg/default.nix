{
  config,
  lib,
  ...
}:
{
  options.media.swayimg = {
    enable = lib.mkEnableOption "Enables swayimg.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.swayimg.package;
      description = "The swayimg package to use.";
    };
  };

  config = lib.mkIf config.media.swayimg.enable {
    programs.swayimg = {
      enable = true;
      initLua = ''
        swayimg.viewer.on_key("h", function()
          local pos = swayimg.viewer.get_position()
          swayimg.viewer.set_abs_position(pos.x + 10, pos.y)
        end)

        swayimg.viewer.on_key("j", function()
          local pos = swayimg.viewer.get_position()
          swayimg.viewer.set_abs_position(pos.x, pos.y - 10)
        end)

        swayimg.viewer.on_key("k", function()
          local pos = swayimg.viewer.get_position()
          swayimg.viewer.set_abs_position(pos.x, pos.y + 10)
        end)

        swayimg.viewer.on_key("l", function()
          local pos = swayimg.viewer.get_position()
          swayimg.viewer.set_abs_position(pos.x - 10, pos.y)
        end)
      '';
    };

    xdg.mimeApps.defaultApplications = {
      "image/avif" = "swayimg.desktop";
      "image/bmp" = "swayimg.desktop";
      "image/gif" = "swayimg.desktop";
      "image/jpeg" = "swayimg.desktop";
      "image/jpg" = "swayimg.desktop";
      "image/png" = "swayimg.desktop";
      "image/svg+xml" = "swayimg.desktop";
      "image/tiff" = "swayimg.desktop";
      "image/webp" = "swayimg.desktop";
      "image/x-bmp" = "swayimg.desktop";
      "image/x-png" = "swayimg.desktop";
      "image/x-tga" = "swayimg.desktop";
    };
  };
}

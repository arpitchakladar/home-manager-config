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
        -- Panning around the image (HJKL)
        swayimg.viewer.on_key("h", function()
          local pos = swayimg.viewer.get_position()
          swayimg.viewer.set_abs_position(pos.x + 20, pos.y)
        end)
        swayimg.viewer.on_key("j", function()
          local pos = swayimg.viewer.get_position()
          swayimg.viewer.set_abs_position(pos.x, pos.y - 20)
        end)
        swayimg.viewer.on_key("k", function()
          local pos = swayimg.viewer.get_position()
          swayimg.viewer.set_abs_position(pos.x, pos.y + 20)
        end)
        swayimg.viewer.on_key("l", function()
          local pos = swayimg.viewer.get_position()
          swayimg.viewer.set_abs_position(pos.x - 20, pos.y)
        end)

        -- File switching
        swayimg.viewer.on_key("n", function() swayimg.viewer.open("next") end)
        swayimg.viewer.on_key("p", function() swayimg.viewer.open("prev") end)

        -- Zoom controls
        swayimg.viewer.on_key("equal", function() swayimg.viewer.reset() end)
        swayimg.viewer.on_key("plus", function()
          swayimg.viewer.scale = swayimg.viewer.scale + 0.1
        end)
        swayimg.viewer.on_key("minus", function()
          swayimg.viewer.scale = swayimg.viewer.scale - 0.1
        end)

        -- Actions
        swayimg.viewer.on_key("q", function() swayimg.exit() end)
        swayimg.viewer.on_key("f", function() swayimg.fullscreen = not swayimg.fullscreen end)
      '';
    };

    xdg.mimeApps.defaultApplications = {
      "image/avif" = "swayimg.desktop";
      "image/bmp" = "swayimg.desktop";
      "image/gif" = "swayimg.desktop";
      "image/heic" = "swayimg.desktop";
      "image/heif" = "swayimg.desktop";
      "image/jpeg" = "swayimg.desktop";
      "image/jpg" = "swayimg.desktop";
      "image/png" = "swayimg.desktop";
      "image/svg+xml" = "swayimg.desktop";
      "image/tiff" = "swayimg.desktop";
      "image/webp" = "swayimg.desktop";
      "image/x-bmp" = "swayimg.desktop";
      "image/x-png" = "swayimg.desktop";
      "image/x-tga" = "swayimg.desktop";
      "image/x-icon" = "swayimg.desktop";
    };
  };
}

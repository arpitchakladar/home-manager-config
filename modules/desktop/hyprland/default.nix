{
  config,
  lib,
  pkgs,
  ...
}:
let
  toHyprColor = hex: "rgba(${lib.removePrefix "#" hex}ff)";
in
{
  imports = [
    ./hyprpaper.nix
    ./keybindings.nix
  ];

  options.desktop.hardware.gpu = {
    nvidia.enable = lib.mkEnableOption "Nvidia GPU Wayland/Hyprland optimizations";

    amd.enable = lib.mkEnableOption "AMD GPU Wayland/Hyprland optimizations";

    primaryCard = lib.mkOption {
      type = lib.types.str;
      default = "/dev/dri/by-path/pci-0000:05:00.0-card";
      description = "Path to primary DRM card device for Aquamarine/Hyprland rendering";
    };

    secondaryCard = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "/dev/dri/by-path/pci-0000:01:00.0-card";
      description = "Path to secondary DRM card device for offloading (null if single GPU)";
    };
  };

  config = lib.mkIf config.desktop.enable {

    home.sessionVariables = lib.mkMerge [
      {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        GDK_SCALE = "1";
        QT_SCALE_FACTOR = "1";

        AQ_DRM_DEVICES =
          if config.desktop.hardware.gpu.secondaryCard != null then
            "${config.desktop.hardware.gpu.primaryCard}:${config.desktop.hardware.gpu.secondaryCard}"
          else
            config.desktop.hardware.gpu.primaryCard;
      }

      (lib.mkIf config.desktop.hardware.gpu.nvidia.enable {
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        NVD_BACKEND = "direct";

        AQ_NO_MODIFIERS = "1";
        __GL_YIELD = "USLEEP";
        __GL_VRR_ALLOWED = "0";
      })

      (lib.mkIf config.desktop.hardware.gpu.amd.enable {
        AMD_VULKAN_ICD = "RADV";
        MESA_VK_DEVICE_SELECT = "1002:";
      })
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      xwayland.enable = true;
      systemd.enable = true;

      settings = {
        monitor = [
          {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = 1;
          }
        ];
        mainMod = {
          _var = "SUPER";
        };

        config = {
          general = with config.scheme.withHashtag; {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 1;
            col = {
              active_border = {
                colors = [ (toHyprColor base07) ];
                angle = 45;
              };
              inactive_border = toHyprColor base03;
            };
            layout = "scrolling";
          };

          xwayland = {
            force_zero_scaling = true;
          };

          scrolling = {
            column_width = 0.5;
            explicit_column_widths = "0.5, 1.0";
            focus_fit_method = 1;
            follow_focus = true;
          };

          debug = {
            vfr = true;
          };

          misc = {
            vrr = lib.mkIf config.desktop.hardware.gpu.amd.enable 1;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };

          decoration = {
            rounding = 0;
            blur = {
              enabled = false;
            };
            shadow = {
              enabled = false;
            };
          };

          input = {
            follow_mouse = 1;
            kb_layout = "us";
          };

          cursor = {
            enable_hyprcursor = true;
            no_hardware_cursors = config.desktop.hardware.gpu.nvidia.enable;
          };

          dwindle = {
            preserve_split = true;
          };
        };
      };
    };

    home.pointerCursor = {
      enable = true;
      package = pkgs.rose-pine-hyprcursor;
      name = "rose-pine-hyprcursor";
      size = 20;
      hyprcursor.enable = true;
      gtk.enable = false;
      x11.enable = false;
    };
  };
}

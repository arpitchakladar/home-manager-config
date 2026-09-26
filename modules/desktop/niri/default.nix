# Niri scrollable-tiling Wayland compositor and desktop essentials
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop;
  base16Colors = import ../../colors/base16 { inherit config lib pkgs; };
in
{
  imports = [
    ./keybindings.nix
    ./assertions.nix
  ];

  options.desktop = {
    niri = lib.mkOption {
      type = lib.types.submodule {
        options = {
          package = lib.mkOption {
            type = lib.types.package;
            readOnly = true;
            default = config.wayland.windowManager.niri.package;
            description = "The niri package to use.";
          };
        };
      };
      default = { };
      description = "Niri window manager configuration.";
    };
    hardware.gpu = {
      nvidia = lib.mkOption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "Nvidia GPU Wayland optimizations";
          };
        };
        default = { };
        description = "NVIDIA GPU configuration.";
      };
      amd = lib.mkOption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "AMD GPU Wayland optimizations";
          };
        };
        default = { };
        description = "AMD GPU configuration.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = lib.mkMerge [
      {
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        GDK_SCALE = "1";
        QT_SCALE_FACTOR = "1";
      }

      (lib.mkIf cfg.hardware.gpu.nvidia.enable {
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GL_YIELD = "USLEEP";
        __GL_VRR_ALLOWED = "0";
      })

      (lib.mkIf cfg.hardware.gpu.amd.enable {
        AMD_VULKAN_ICD = "RADV";
        MESA_VK_DEVICE_SELECT = "1002:";
      })
    ];

    wayland.windowManager.niri = {
      enable = true;
      systemd.enable = true;
      # Don't let Niri register its own portal. We will use xdg.portal for the
      # configuration of portal
      portalPackage = null;
    };

    # For setting the desktop wallpaper
    home.packages = [ pkgs.swaybg ];

    home.pointerCursor = {
      enable = true;
      package = pkgs.vimix-cursors;
      name = "Vimix-cursors";
      size = 20;
      gtk.enable = true;
      x11.enable = true;
    };

    wayland.windowManager.niri.settings = with base16Colors.colorsWithHashPrefix; {
      hotkey-overlay = {
        skip-at-startup = { };
      };
      input = {
        keyboard.xkb.layout = "us";
        touchpad = {
          natural-scroll = { };
          tap = { };
          dwt = { };
          click-method = "clickfinger";
          accel-speed = 0.5;
        };
      };
      layer-rule._children = [
        { "match namespace=\"^wallpaper$\"" = { }; }
        { place-within-backdrop = true; }
      ];
      layout = {
        gaps = 5;
        struts = {
          right = 60;
        };
        center-focused-column = "on-overflow";
        default-column-width = {
          proportion = 1.0;
        };
        background-color = "transparent";
        focus-ring = {
          width = 1;
          active-color = base07;
          inactive-color = base03;
        };
        border.off = { };
        shadow.off = { };
        preset-column-widths._children = [
          { proportion = 0.5; }
          { proportion = 1.0; }
        ];
      };
      prefer-no-csd = true;
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      animations.on = { };
      spawn-at-startup = [
        "${lib.getExe pkgs.swaybg}"
        "-i"
        "${../../../assets/sapling.png}"
        "-m"
        "fill"
      ];
    };

    desktop.rofi.action.actions = [
      {
        name = "Poweroff Monitors";
        command = "${lib.getExe cfg.niri.package} msg action power-off-monitors";
        icon = config.desktop.icons.apps.niriPowerOffMonitors;
      }
    ];
  };
}

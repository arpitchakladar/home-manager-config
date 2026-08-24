{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./keybindings.nix ];

  options.desktop.hardware.gpu = {
    nvidia.enable = lib.mkEnableOption "Nvidia GPU Wayland optimizations";
    amd.enable = lib.mkEnableOption "AMD GPU Wayland optimizations";
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
      }

      (lib.mkIf config.desktop.hardware.gpu.nvidia.enable {
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GL_YIELD = "USLEEP";
        __GL_VRR_ALLOWED = "0";
      })

      (lib.mkIf config.desktop.hardware.gpu.amd.enable {
        AMD_VULKAN_ICD = "RADV";
        MESA_VK_DEVICE_SELECT = "1002:";
      })
    ];

    wayland.windowManager.niri = {
      enable = true;
      systemd.enable = true;
      # Let Niri register its recommended GNOME portal implementation.
      portalPackage = pkgs.xdg-desktop-portal-gnome;
    };

    home.packages = [ pkgs.swaybg ];

    home.pointerCursor = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 20;
      gtk.enable = true;
      x11.enable = true;
    };

    wayland.windowManager.niri.extraConfigEarly = ''
      input {
        keyboard {
          xkb {
            layout "us"
          }
        }
        touchpad {
          natural-scroll
          tap
          dwt
          click-method "clickfinger"
          accel-speed 0.5
        }
      }

      layout {
        gaps 5
        center-focused-column "on-overflow"
        default-column-width { proportion 1.0; }
        preset-column-widths {
          proportion 0.5
          proportion 1.0
        }
        focus-ring {
          width 1
          active-color "${config.scheme.withHashtag.base07}"
          inactive-color "${config.scheme.withHashtag.base03}"
        }
        border { off; }
        shadow { off; }
      }

      prefer-no-csd
      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
      animations { off; }

      spawn-at-startup "${lib.getExe pkgs.swaybg}" "-i" "${../../../assets/sapling.png}" "-m" "fill"

      // Keep the familiar numbered workspaces persistent; Niri otherwise uses dynamic workspaces.
      workspace "1"
      workspace "2"
      workspace "3"
      workspace "4"
      workspace "5"
      workspace "6"
      workspace "7"
      workspace "8"
      workspace "9"
      workspace "10"
    '';
  };
}

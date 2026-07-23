{ config, lib, ... }:
{
  config = lib.mkIf config.file-management.yazi.enable {
    programs.yazi.theme = with config.scheme.withHashtag; {
      manager = {
        cwd = {
          fg = base0D;
        };

        hovered = {
          fg = base00;
          bg = base0D;
        };
        preview_hovered = {
          underline = true;
        };

        find_keyword = {
          fg = base0A;
          italic = true;
        };
        find_position = {
          fg = base0C;
          bg = base00;
          italic = true;
        };

        marker_selected = {
          fg = base0B;
          bg = base0B;
        };
        marker_copied = {
          fg = base0A;
          bg = base0A;
        };
        marker_cut = {
          fg = base08;
          bg = base08;
        };

        tab_active = {
          fg = base00;
          bg = base0D;
        };
        tab_inactive = {
          fg = base05;
          bg = base01;
        };

        count_copied = {
          fg = base00;
          bg = base0A;
        };
        count_cut = {
          fg = base00;
          bg = base08;
        };
        count_selected = {
          fg = base00;
          bg = base0B;
        };

        border_symbol = "│";
        border_style = {
          fg = base02;
        };

        syntect_theme = "";
      };

      status = {
        separator_open = "";
        separator_close = "";
        separator_style = {
          fg = base01;
          bg = base01;
        };

        mode_normal_main = {
          fg = base00;
          bg = base0D;
          bold = true;
        };
        mode_normal_alt = {
          fg = base0D;
          bg = base01;
        };

        mode_select_main = {
          fg = base00;
          bg = base0B;
          bold = true;
        };
        mode_select_alt = {
          fg = base0B;
          bg = base01;
        };

        mode_unset_main = {
          fg = base00;
          bg = base0E;
          bold = true;
        };
        mode_unset_alt = {
          fg = base0E;
          bg = base01;
        };

        progress_label = {
          fg = base06;
          bold = true;
        };
        progress_normal = {
          fg = base0D;
          bg = base01;
        };
        progress_error = {
          fg = base08;
          bg = base01;
        };

        permissions_t = {
          fg = base0D;
        };
        permissions_r = {
          fg = base0A;
        };
        permissions_w = {
          fg = base08;
        };
        permissions_x = {
          fg = base0B;
        };
        permissions_s = {
          fg = base03;
        };
      };

      input = {
        border = {
          fg = base0D;
        };
        selected = {
          reversed = true;
        };
      };

      select = {
        border = {
          fg = base0D;
        };
        active = {
          fg = base0E;
        };
      };

      tasks = {
        border = {
          fg = base0D;
        };
        hovered = {
          underline = true;
        };
      };

      which = {
        mask = {
          bg = base01;
        };
        cand = {
          fg = base0C;
        };
        rest = {
          fg = base04;
        };
        desc = {
          fg = base0D;
        };
        separator = "  ";
        separator_style = {
          fg = base03;
        };
      };

      notify = {
        title_info = {
          fg = base0D;
        };
        title_warn = {
          fg = base0A;
        };
        title_error = {
          fg = base08;
        };
      };

      pick = {
        border = {
          fg = base0D;
        };
        active = {
          fg = base0E;
        };
      };

      confirm = {
        border = {
          fg = base0D;
        };
      };

      completion = {
        border = {
          fg = base0D;
        };
        active = {
          fg = base00;
          bg = base0D;
        };
        icon_file = "";
        icon_folder = "";
        icon_command = "";
      };

      mode = {
        normal_main = {
          fg = base00;
          bg = base0D;
          bold = true;
        };
        normal_alt = {
          fg = base0D;
          bg = base01;
        };

        select_main = {
          fg = base00;
          bg = base0B;
          bold = true;
        };
        select_alt = {
          fg = base0B;
          bg = base01;
        };

        unset_main = {
          fg = base00;
          bg = base0E;
          bold = true;
        };
        unset_alt = {
          fg = base0E;
          bg = base01;
        };
      };
    };
  };
}

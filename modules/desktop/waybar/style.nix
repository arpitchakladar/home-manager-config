{ config }:
with config.scheme.withHashtag;
''
  * {
    border: none;
    border-radius: 0;
    font-family: "${config.fonts.normal}";
    font-size: ${toString config.fonts.size}px;
    min-height: 0;
  }

  window#waybar {
    background: ${base00};
    color: ${base05};
  }

  #workspaces button {
    padding: 0 4px;
    color: ${base05};
  }

  #workspaces button.focused {
    border-bottom: 3px solid ${base0D};
  }

  #workspaces button.urgent {
    border-bottom: 3px solid ${base08};
  }
''

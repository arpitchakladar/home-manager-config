{ config }:
with config.scheme.withHashtag;
''
  * {
    border: none;
    border-radius: 0;
    font-family: "${config.fonts.normal}";
    font-size: ${toString config.fonts.size}px;
    min-height: 0;
    margin: 0;
    padding: 0;
  }

  #workspaces, #window, #pulseaudio, #battery, #custom-vpn, #network,
  #clock.time, #memory, #cpu, #clock.date {
    background: ${base00};
    margin: 0 5px;
  }

  #workspaces {
    border: none;
    margin-right: 0;
  }

  #window, #pulseaudio, #battery, #custom-vpn, #network,
  #clock.time, #memory, #cpu, #clock.date {
    border: 1px solid ${base07};
    color: ${base07};
    padding: 0 10px;
  }

  #clock.date {
    margin-right: 10px;
  }

  #workspaces button {
    padding: 0px 5px;
    color: ${base07};
    border: 1px solid ${base03};
    border-radius: 0;
    min-width: 0px;
    min-height: 0px;
    margin: 0 5px;
    font-size: 24px;
  }

  #workspaces button:hover {
    background: ${base01};
  }

  #workspaces button.active {
    border-color: ${base07};
  }

  #workspaces button.empty {
    color: ${base03};
  }

  #workspaces button.urgent {
    color: ${base08};
  }
''

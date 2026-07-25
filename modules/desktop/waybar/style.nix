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
    margin: 0 2px;
  }

  #window {
    margin-right: 3px;
  }

  #workspaces {
    border: none;
    margin-left: 3px;
  }

  #clock.date {
    margin-right: 5px;
  }

  #window, #pulseaudio, #battery, #custom-vpn, #network,
  #clock.time, #memory, #cpu, #clock.date {
    border: 1.5px solid ${base03};
    color: ${base07};
    padding: 0 8px;
  }

  #workspaces button {
    padding: 3px;
    color: ${base07};
    border: 1.5px solid ${base03};
    border-radius: 0;
    min-width: 24px;
    min-height: 24px;
    margin: 0 2px;
  }

  #workspaces button:hover {
    background: ${base01};
  }

  #workspaces button.active {
    background: ${base03};
  }

  #workspaces button.urgent {
    color: ${base08};
  }
''

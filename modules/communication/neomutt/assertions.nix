{ config, ... }:

{
  assertions = [
    {
      assertion = !config.communication.neomutt.enable || config.terminal.less.enable;
      message = ''
        communication.neomutt is enabled but terminal.less.enable is not.
        neomutt requires less as its pager. Please enable terminal.less.
      '';
    }
    {
      assertion = !config.communication.neomutt.enable || config.terminal.bat.enable;
      message = ''
        communication.neomutt is enabled but terminal.bat.enable is not.
        neomutt requires bat for text/html filtering. Please enable terminal.bat.
      '';
    }
    {
      assertion = !config.communication.neomutt.enable || config.communication.email.enable;
      message = ''
        communication.neomutt is enabled but communication.email.enable is not.
        neomutt requires the email module (mbsync + notmuch) to be enabled.
      '';
    }
    {
      assertion = !config.communication.neomutt.enable || config.terminal.kitty.enable;
      message = ''
        communication.neomutt is enabled but terminal.kitty.enable is not.
        neomutt's desktop entry requires kitty as the terminal launcher. Please enable terminal.kitty.
      '';
    }
  ];
}

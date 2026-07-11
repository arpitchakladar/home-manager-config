{ config, ... }:

{
  assertions = [
    {
      assertion = !config.programs.neomutt.enable || config.programs.less.enable;
      message = ''
        programs.neomutt is enabled but programs.less.enable is not.
        neomutt requires less as its pager. Please enable programs.less.
      '';
    }
    {
      assertion = !config.programs.neomutt.enable || config.programs.bat.enable;
      message = ''
        programs.neomutt is enabled but programs.bat.enable is not.
        neomutt requires bat for text/html filtering. Please enable programs.bat.
      '';
    }
    {
      assertion = !config.programs.neomutt.enable || config.programs.email.enable;
      message = ''
        programs.neomutt is enabled but programs.email.enable is not.
        neomutt requires the email module (mbsync + notmuch) to be enabled.
      '';
    }
    {
      assertion = !config.programs.neomutt.enable || config.programs.kitty.enable;
      message = ''
        programs.neomutt is enabled but programs.kitty.enable is not.
        neomutt's desktop entry requires kitty as the terminal launcher. Please enable programs.kitty.
      '';
    }
  ];
}

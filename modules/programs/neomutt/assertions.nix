{ config, ... }:

{
  assertions = [
    {
      assertion = !config.programs.meli.enable || config.programs.less.enable;
      message = ''
        programs.meli is enabled but programs.less.enable is not.
        meli requires less as its pager. Please enable programs.less.
      '';
    }
    {
      assertion = !config.programs.meli.enable || config.programs.bat.enable;
      message = ''
        programs.meli is enabled but programs.bat.enable is not.
        meli requires bat for text/html filtering. Please enable programs.bat.
      '';
    }
    {
      assertion = !config.programs.meli.enable || config.programs.email.enable;
      message = ''
        programs.meli is enabled but programs.email.enable is not.
        meli requires the email module (mbsync + notmuch) to be enabled.
      '';
    }
  ];
}

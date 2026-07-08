{ config, ... }:
{
  assertions = [
    {
      assertion = !config.programs.aerc.enable || config.programs.less.enable;
      message = ''
        programs.aerc is enabled but programs.less.enable is not.
        aerc requires less as its pager. Please enable programs.less.
      '';
    }
    {
      assertion = !config.programs.aerc.enable || config.programs.bat.enable;
      message = ''
        programs.aerc is enabled but programs.bat.enable is not.
        aerc requires bat for text/html filtering. Please enable programs.bat.
      '';
    }
  ];
}

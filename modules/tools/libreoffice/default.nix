{
  config,
  lib,
  pkgs,
  ...
}:

# LibreOffice - Open-source office suite (Word, Excel, PowerPoint alternative)
{
  options.tools.libreoffice = {
    enable = lib.mkEnableOption "Enables libreoffice.";
  };

  config = lib.mkIf config.tools.libreoffice.enable {
    home.packages = with pkgs; [
      libreoffice
    ];
  };
}

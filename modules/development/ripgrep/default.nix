# recursively search for a given regex
{
  config,
  lib,
  ...
}:
{
  options.development.ripgrep = {
    enable = lib.mkEnableOption "Enables ripgrep.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = config.programs.ripgrep.package;
      description = "The ripgrep package to use.";
    };
  };

  config = lib.mkIf config.development.ripgrep.enable {
    programs.ripgrep = {
      enable = true;
    };
  };
}

# neomutt - Terminal email client
{
  config,
  lib,
  ...
}:

{
  imports = [
    ./assertions.nix
    ./theme.nix
  ];

  config = lib.mkIf config.programs.neomutt.enable {
    programs.neomutt = {
      sidebar.enable = true;
      sort = "reverse-threads";
      vimKeys = true;
    };
  };
}

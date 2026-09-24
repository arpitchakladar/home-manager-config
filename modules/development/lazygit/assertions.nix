# LazyGit only makes sense when Git is enabled
{ config, ... }:
let
  cfg = config.development.lazygit;
in
{
  assertions = [
    {
      assertion = !cfg.enable || config.development.git.enable;
      message = "development.lazygit.enable requires development.git.enable.";
    }
  ];
}

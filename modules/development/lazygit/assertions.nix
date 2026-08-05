# LazyGit only makes sense when Git is enabled
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.development.lazygit.enable || config.development.git.enable;
      message = "development.lazygit.enable requires development.git.enable.";
    }
  ];
}

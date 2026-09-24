# Validates Senpai dependencies.
{ config, ... }:
let
  cfg = config.communication.senpai;
in
{
  assertions = [
    {
      assertion = !cfg.enable || cfg.server.address != "";
      message = "communication.senpai.enable requires communication.senpai.server.address to be set.";
    }
    {
      assertion = !cfg.enable || cfg.identity.nickname != "";
      message = "communication.senpai.enable requires communication.senpai.identity.nickname to be set.";
    }
    {
      assertion = cfg.identity.password-gopass-secret == null || config.security.gopass.enable;
      message = "communication.senpai.identity.password-gopass-secret requires security.gopass.enable.";
    }
  ];
}

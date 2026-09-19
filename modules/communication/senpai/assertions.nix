# Validates Senpai dependencies.
{ config, ... }:
{
  assertions = [
    {
      assertion = !config.communication.senpai.enable || config.communication.senpai.server.address != "";
      message = "communication.senpai.enable requires communication.senpai.server.address to be set.";
    }
    {
      assertion =
        !config.communication.senpai.enable || config.communication.senpai.identity.nickname != "";
      message = "communication.senpai.enable requires communication.senpai.identity.nickname to be set.";
    }
    {
      assertion =
        config.communication.senpai.identity.passwordGopassSecret == null || config.security.gopass.enable;
      message = "communication.senpai.identity.passwordGopassSecret requires security.gopass.enable.";
    }
  ];
}

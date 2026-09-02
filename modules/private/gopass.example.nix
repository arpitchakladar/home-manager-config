# Gopass - Template for configuring gopass, specially syncing
{ ... }:
{
  config = {
    security.gopass.sync = {
      remote = "YOUR_REPOSITORY_URL";
      credential = {
        username = "example";
        passwordGopassPath = "websites/github.com/example/tokens/calendar";
      };
    };
  };
}

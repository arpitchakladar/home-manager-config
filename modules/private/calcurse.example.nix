# Calcurse - Template for configuring calcurse, specially syncing
{ ... }:
{
  config = {
    office.calcurse.sync = {
      remote = "YOUR_REPOSITORY_URL";
      credential = {
        username = "example";
        passwordGopassPath = "websites/github.com/example/tokens/calendar";
      };
    };
  };
}

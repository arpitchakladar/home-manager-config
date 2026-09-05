# Git example - Template for configuring git identity and signing
{ ... }:
{
  config = {
    development.git = {
      username = "Your Name";
      email = "you@example.com";
      signing = {
        key = "EXAMPLE_GPG_KEY_ID";
        signByDefault = true;
      };
    };

    # SSH keys to load from gopass (entries under ssh/ in the gopass store)
    security.ssh.gopassKeys = [
      "github"
      "gitlab"
    ];
  };
}

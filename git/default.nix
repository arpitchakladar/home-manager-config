{ ... }:

{
	programs.git.enable = true;
	programs.git.userEmail = "54011232+arpitchakladar@users.noreply.github.com";
	programs.git.userName = "Arpit Chakladar";
	programs.git.extraConfig.credential.helper = "store --file ~/.cache/git/credential";
}

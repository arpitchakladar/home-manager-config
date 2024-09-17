{ ... }:

{
	programs.git = {
		enable = true;
		userEmail = "54011232+arpitchakladar@users.noreply.github.com";
		userName = "Arpit Chakladar";
		extraConfig.credential.helper = "store --file ~/.cache/git/credential";
	};
}

{ pkgs, ... }:

{
	programs.lf.enable = true;
	programs.lf.settings = {
		hidden = true;
	};

	programs.lf.extraConfig = "set icons";

	xdg.configFile."lf/icons".source = builtins.fetchurl {
		url = "https://raw.githubusercontent.com/gokcehan/lf/master/etc/icons.example";
		sha256 = "sha256:12cwy6kfa2wj7nzffaxn5bka21yjqa5sx38nzdhyg1dq0c6jnjkk";
	};
}

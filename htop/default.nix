{ pkgs, ... }:

{
	programs.htop.enable = true;
	programs.htop.package = pkgs.htop-vim;
}

{ config, pkgs, lib, ... }:

{
	options.tools.cloudflare-warp = {
		enable = lib.mkEnableOption "Enables cloudflare-warp.";
	};

	config = lib.mkIf config.tools.cloudflare-warp.enable {
		home.packages = with pkgs; [
			cloudflare-warp
		];
	};
}

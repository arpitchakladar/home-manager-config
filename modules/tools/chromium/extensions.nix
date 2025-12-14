{ config, lib, ... }:

{
	config = lib.mkIf config.tools.chromium.enable {
		# NOTE: Currently doesn't work for brave
		programs.chromium.extensions = [
			{
				id = "hfjbmagddngcpeloejdejnfgbamkjaeg"; # Vimium C
			}
			{
				id = "nngceckbapebfimnlniiiahkandclblb"; # Bitwarden Password Manager
			}
			{
				id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; # Dark Reader
			}
			{
				id = "mkplpffahhkjfocfbfapcemhhkgmljpn"; # All Black - Full Dark Theme/Black Theme
			}
		];
	};
}

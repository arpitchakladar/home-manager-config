{ lib, config, ... }:

{
	imports = [
		./editor
		./file-manager
		./git
		./system-monitor
		./viewer
	];
}

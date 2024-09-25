{ createKeybinding, pkgs }:

let
	bspc = "${pkgs.bspwm}/bin/bspc";
in {
	${(createKeybinding
		"q"
		"Kill current window.")}
			= "${bspc} node -c";

	${(createKeybinding
		"{1-9,0}"
		"Switch workspace.")}
			= "${bspc} desktop -f {1-9,10}";

	${(createKeybinding
		"shift + {1-9,0}"
		"Move window to workspace.")}
			= "${bspc} node -d {1-9,10} --follow";

	${(createKeybinding
		"{n,d,m}"
		"Set current window mode (tiled, floating, fullscreen).")}
			= "${bspc} node focused -t {tiled,floating,fullscreen}";

	${(createKeybinding
		"{_,shift + }{h,j,k,l}"
		"Navigate between windows.")}
			= "${bspc} node --{focus,swap} {west,south,north,east}";

	# the indentation for each line is required to work with the help prompt
	${(createKeybinding
		"ctrl + {h,j,k,l}"
		"Resize current window.")}
			= ''
	${bspc} node {@parent/second -z left -20 0; \
	@parent/first -z right -20 0, \
	@parent/second -z top 0 +20; \
	@parent/first -z bottom 0 +20, \
	@parent/first -z bottom 0 -20; \
	@parent/second -z top 0 -20, \
	@parent/first -z right +20 0; \
	@parent/second -z left +20 0}
'';
}

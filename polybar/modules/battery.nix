config:

with config.lib.stylix.colors.withHashtag;
{
	type = "internal/battery";
	battery = "BAT0";
	adapter = "ADP1";
	full-at = "98";

	format-charging = "<animation-charging> <label-charging>";
	format-discharging = "<ramp-capacity> <label-discharging>";
	format-full-prefix = "%{F${base0B}}󱊣%{F-}";
	label-full = "%percentage_used%%";

	ramp-capacity-0 = "%{F${base0C}}󱊡%{F-}";
	ramp-capacity-1 = "%{F${base0C}}󱊢%{F-}";
	ramp-capacity-2 = "%{F${base0C}}󱊣%{F-}";

	animation-charging-0 = "%{F${base0C}}󱊡%{F-}";
	animation-charging-1 = "%{F${base0C}}󱊢%{F-}";
	animation-charging-2 = "%{F${base0C}}󱊣%{F-}";
	animation-charging-framerate = 750;
}

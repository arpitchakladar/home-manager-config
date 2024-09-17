config:

with config.lib.stylix.colors.withHashtag;
{
	type = "internal/battery";
	battery = "BAT0";
	adapter = "ADP1";

	format-charging = "<animation-charging> <label-charging>";
	format-discharging = "<ramp-capacity> <label-discharging>";
	format-full-prefix = "%{F${base0B}}󰁹%{F-}";

	ramp-capacity-0 = "%{F${base0C}}󰁺%{F-}";
	ramp-capacity-1 = "%{F${base0C}}󰁻%{F-}";
	ramp-capacity-2 = "%{F${base0C}}󰁼%{F-}";
	ramp-capacity-3 = "%{F${base0C}}󰁽%{F-}";
	ramp-capacity-4 = "%{F${base0C}}󰁾%{F-}";
	ramp-capacity-5 = "%{F${base0C}}󰁿%{F-}";
	ramp-capacity-6 = "%{F${base0C}}󰂀%{F-}";
	ramp-capacity-7 = "%{F${base0C}}󰂁%{F-}";
	ramp-capacity-8 = "%{F${base0C}}󰂂%{F-}";
	ramp-capacity-9 = "%{F${base0C}}󰁹%{F-}";

	animation-charging-0 = "%{F${base0C}}󰁺%{F-}";
	animation-charging-1 = "%{F${base0C}}󰁻%{F-}";
	animation-charging-2 = "%{F${base0C}}󰁼%{F-}";
	animation-charging-3 = "%{F${base0C}}󰁽%{F-}";
	animation-charging-4 = "%{F${base0C}}󰁾%{F-}";
	animation-charging-5 = "%{F${base0C}}󰁿%{F-}";
	animation-charging-6 = "%{F${base0C}}󰂀%{F-}";
	animation-charging-7 = "%{F${base0C}}󰂁%{F-}";
	animation-charging-8 = "%{F${base0C}}󰂂%{F-}";
	animation-charging-9 = "%{F${base0C}}󰁹%{F-}";

	animation-charging-framerate = 750;
}

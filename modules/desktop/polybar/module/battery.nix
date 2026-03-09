{ config }:

with config.scheme.withHashtag;
{
	type = "internal/battery";
	battery = "BAT1";
	adapter = "ADP1";
	
	low-at = 0;
	format-charging = "%{T2}%{F${base03}}<animation-charging>%{F-}%{T-} <label-charging>";
	format-discharging = "%{T2}%{F${base03}}<ramp-capacity>%{F-}%{T-} <label-discharging>";
	format-full-prefix = "󰁹 ";
	
	label-charging = "%percentage:3%%";
	label-discharging = "%percentage:3%%";
	
	ramp-capacity-0 = "󰁺";
	ramp-capacity-1 = "󰁻";
	ramp-capacity-2 = "󰁼";
	ramp-capacity-3 = "󰁽";
	ramp-capacity-4 = "󰁾";
	ramp-capacity-5 = "󰁿";
	ramp-capacity-6 = "󰂀";
	ramp-capacity-7 = "󰂁";
	ramp-capacity-8 = "󰂂";
	ramp-capacity-9 = "󰁹";
	
	animation-charging-0 = "󰁺";
	animation-charging-1 = "󰁻";
	animation-charging-2 = "󰁼";
	animation-charging-3 = "󰁽";
	animation-charging-4 = "󰁾";
	animation-charging-5 = "󰁿";
	animation-charging-6 = "󰂀";
	animation-charging-7 = "󰂁";
	animation-charging-8 = "󰂂";
	animation-charging-9 = "󰁹";
	
	animation-charging-framerate = 750;
}

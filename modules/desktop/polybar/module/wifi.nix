{ config }:

with config.scheme.withHashtag;
{
	type = "internal/network";
	interface = "wlan0";
	interface-type = "wireless";

	format-connected = "%{T2}%{F${base03}}<ramp-signal>%{F-}%{T-} <label-connected>";
	format-disconnected = "";

	label-connected = "%netspeed:8%";
	label-disconnected = "";

	ramp-signal-0 = "󰢼";
	ramp-signal-1 = "󰢼";
	ramp-signal-2 = "󰢽";
	ramp-signal-3 = "󰢽";
	ramp-signal-4 = "󰢾";
	ramp-signal-5 = "󰢾";
}

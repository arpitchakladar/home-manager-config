{ config }:

with config.scheme.withHashtag;
{
	type = "internal/network";
	interface = "wlan0";
	interface-type = "wireless";

	format-connected = " %{F${base03}}%{T3}│%{T-}%{F-} ";
	format-disconnected = "";

	label-connected = "";
	label-disconnected = "";
}

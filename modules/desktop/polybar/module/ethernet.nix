{ config }:

with config.scheme.withHashtag;
{
	type = "internal/network";
	interface = "enp4s0";
	interface-type = "wired";

	format-connected = "%{T2}%{F${base03}}%{F-}%{T-} <label-connected>";
	format-disconnected = "";

	label-connected = "%netspeed:8%";
	label-disconnected = "";
}

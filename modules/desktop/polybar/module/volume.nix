{ config }:

with config.scheme.withHashtag;
{
	type = "internal/pulseaudio";
	interval = 5;
	format-volume = "%{T2}%{F${base03}}<ramp-volume>%{F-}%{T-} <label-volume>";
	label-volume = "%percentage:3%%";
	label-muted = "%{T2}%{F${base03}} %{F-}%{T-}     ";
	ramp-volume-0 = " ";
	ramp-volume-1 = " ";
	ramp-volume-2 = " ";
}

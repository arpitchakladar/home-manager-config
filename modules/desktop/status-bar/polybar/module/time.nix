{ config }:

with config.scheme.withHashtag;
{
	type = "internal/date";
	interval = 30;
	time = "%H:%M";
	label = "%time%";
	format-prefix = "%{T2}%{F${base07}}  %{F-}%{T-}";
}

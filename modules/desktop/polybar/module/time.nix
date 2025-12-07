{ config }:

with config.scheme.withHashtag;
{
	type = "internal/date";
	interval = 30;
	time = "%I:%M %p";
	label = "%time%";
	format-prefix = "%{T2}%{F${base03}} %{F-}%{T-}";
}

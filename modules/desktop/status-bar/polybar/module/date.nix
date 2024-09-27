{ config }:

with config.scheme.withHashtag;
{
	type = "internal/date";
	interval = 60;
	date = "%d/%m/%Y";
	label = "%date%";
	format-prefix = "%{T2}%{F${base07}}  %{F-}%{T-}";
}

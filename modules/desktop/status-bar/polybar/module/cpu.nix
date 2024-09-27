{ config }:

with config.scheme.withHashtag;
{
	type = "internal/cpu";
	interval = 2;
	format-prefix = "%{T2}%{F${base07}}  %{F-}%{T-}";
	label = "%percentage%%";
}

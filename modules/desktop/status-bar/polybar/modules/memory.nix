{ config }:

with config.scheme.withHashtag;
{
	type = "internal/memory";
	interval = 2;
	format-prefix = "%{F${base0A}}  %{F-}";
	label = "%percentage_used%%";
}

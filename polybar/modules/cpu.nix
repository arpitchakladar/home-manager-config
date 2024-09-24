config:

with config.scheme.withHashtag;
{
	type = "internal/cpu";
	interval = 2;
	format-prefix = "%{F${base09}}  %{F-}";
	label = "%percentage%%";
}

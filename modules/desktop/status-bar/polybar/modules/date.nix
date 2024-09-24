config:

with config.scheme.withHashtag;
{
	type = "internal/date";
	interval = 60;
	date = "%d/%m/%Y";
	label = "%date%";
	format-prefix = "%{F${base0B}}  %{F-}";
}

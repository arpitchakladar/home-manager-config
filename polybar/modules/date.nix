config:

with config.lib.stylix.colors.withHashtag;
{
	type = "internal/date";
	interval = 60;
	date = "%d/%m/%Y";
	label = "%date%";
	format-prefix = "%{F${base0B}}  %{F-}";
}

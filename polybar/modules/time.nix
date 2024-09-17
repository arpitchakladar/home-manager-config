config:

with config.lib.stylix.colors.withHashtag;
{
	type = "internal/date";
	interval = 30;
	time = "%H:%M";
	label = "%time%";
	format-prefix = "%{F${base0C}}  %{F-}";
}

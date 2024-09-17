config:

with config.lib.stylix.colors.withHashtag;
{
	type = "custom/script";
	exec = "uname -r";
	interval = 1024;
	format-prefix = "%{F${base03}}  %{F-}";
	label = "%output%";
}

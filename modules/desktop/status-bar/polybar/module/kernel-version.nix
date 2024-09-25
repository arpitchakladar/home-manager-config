{ config }:

with config.scheme.withHashtag;
{
	type = "custom/script";
	exec = "uname -r";
	interval = 1024;
	format-prefix = "%{F${base03}}  %{F-}";
	label = "%output%";
}

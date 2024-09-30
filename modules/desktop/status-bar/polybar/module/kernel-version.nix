{ config }:

with config.scheme.withHashtag;
{
	type = "custom/script";
	exec = "uname -r";
	interval = 1024;
	format-prefix = "%{T2}%{F${base03}}  %{F-}%{T-}";
	label = "%output%";
}

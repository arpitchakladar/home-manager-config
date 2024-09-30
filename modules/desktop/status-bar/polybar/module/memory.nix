{ config }:

with config.scheme.withHashtag;
{
	type = "internal/memory";
	interval = 2;
	format-prefix = "%{T2}%{F${base03}}  %{F-}%{T-}";
	label = "%percentage_used%%";
}

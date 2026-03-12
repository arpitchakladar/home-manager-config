{ config }:

with config.scheme.withHashtag;
{
  type = "custom/text";
  label = " %{F${base03}}%{T3}│%{T-}%{F-} ";
}

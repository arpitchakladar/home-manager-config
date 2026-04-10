{ config }:

# CPU - CPU usage percentage module
with config.scheme.withHashtag;
{
  type = "internal/cpu";
  interval = 2;
  format-prefix = "%{T2}%{F${base03}} %{F-}%{T-}";
  label = "%percentage:3%%";
}

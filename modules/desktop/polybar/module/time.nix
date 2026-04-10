{ config }:

# Time - Current time display module (12-hour format)
with config.scheme.withHashtag;
{
  type = "internal/date";
  interval = 30;
  time = "%I:%M %p";
  label = "%time%";
  format-prefix = "%{T2}%{F${base03}} %{F-}%{T-}";
}

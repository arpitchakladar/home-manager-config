{
  config,
  lib,
  mkIcon,
  ...
}:
with config.scheme.withHashtag;
let
  iconColor = base08;
in
{
  exec = "${lib.getExe config.scripts.usque-warp.package} status";
  interval = 5;
  return-type = "json";
  hide-empty-text = true;
  format = "${mkIcon iconColor "󰒃"} {}";
}

{ pkgs }:

{
  "XF86MonBrightnessDown" = {
    launch = [
      "${pkgs.brightnessctl}/bin/brightnessctl"
      "set"
      "5%-"
    ];
  };
  "XF86MonBrightnessUp" = {
    launch = [
      "${pkgs.brightnessctl}/bin/brightnessctl"
      "set"
      "+5%"
    ];
  };
}

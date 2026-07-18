{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit ((import ../lib.nix { inherit lib pkgs; })) mkScriptModule;
  base = mkScriptModule {
    name = "file-preview";
    path = ./script.sh;
    description = "Timeout protection (prevents hanging)";
    deps = [
      config.terminal.kitty.package
      config.terminal.bat.package
      config.media.ffmpeg.package
      config.file-management.ouch.package
      pkgs.coreutils
      pkgs.file
      pkgs.findutils
      pkgs.fontconfig
      pkgs.librsvg
      pkgs.antiword
      pkgs.pandoc
      pkgs.poppler-utils
      pkgs.util-linux
    ];
    inherit config;
  };
in
{
  options = base.options;
  config = base.moduleConfig // {
    assertions = base.moduleConfig.assertions ++ (import ./assertions.nix { inherit config lib; });
  };
}

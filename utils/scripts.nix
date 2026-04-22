{
  lib,
  pkgs,
  config,
}:

{
  # We define mkScript as a function that takes the context it needs
  mkScript =
    name: path: env:
    let
      # Logic inside the helper
      defaultShell =
        if (config.tools.zsh.enable or false) then
          (lib.getExe config.programs.zsh.package)
        else
          "/usr/bin/env sh";

      envVars = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (n: v: "export ${n}=\"${toString v}\"") env
      );
    in
    pkgs.writeTextFile {
      inherit name;
      executable = true;
      destination = "/bin/${name}";
      text = ''
        #!${defaultShell}
        ${envVars}
        ${builtins.readFile path}
      '';
    };
}

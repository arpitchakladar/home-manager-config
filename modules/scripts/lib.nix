{ lib, pkgs }:
let
  shell = pkgs.runtimeShell;

  mkScript =
    name: path: description: env: deps:
    let
      descLines = lib.filter (s: s != "") (lib.splitString "\n" description);
      descComment =
        if descLines == [ ] then "" else lib.concatMapStringsSep "\n" (line: "# ${line}") descLines + "\n";
      envVars = lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: "${n}=\"${toString v}\"") env);
      wrappedScript = pkgs.writeTextFile {
        name = name;
        executable = true;
        destination = "/bin/${name}";
        text = ''
          #!${shell}
          ${descComment}${envVars}
          ${builtins.readFile path}
        '';
      };
    in
    pkgs.runCommand name
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        meta.mainProgram = name;
      }
      ''
        mkdir -p $out/bin
        cp ${wrappedScript}/bin/${name} $out/bin/${name}
        chmod +x $out/bin/${name}

        wrapProgram $out/bin/${name} \
          --prefix PATH : ${lib.makeBinPath deps}
      '';

  mkScriptModule =
    {
      name,
      path,
      env ? { },
      deps ? [ ],
      desktop ? null,
      extraLinks ? [ ],
      config,
      description ? "",
    }:
    let
      scriptDrv = mkScript name path description env deps;
    in
    {
      options.scripts.${name} = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to enable the ${name} script.";
        };
        package = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          readOnly = true;
          description = "The derivation for the ${name} script.";
        };
        desktop = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to create a .desktop entry for this script.";
          };
          displayName = lib.mkOption {
            type = lib.types.str;
            default = name;
            description = "Display name for the .desktop entry.";
          };
          icon = lib.mkOption {
            type = lib.types.str;
            default = "kitty";
            description = "Icon for the .desktop entry.";
          };
        };
      };

      moduleConfig = {
        scripts.${name} = lib.mkIf config.scripts.${name}.enable (
          {
            package = scriptDrv;
          }
          // lib.optionalAttrs (desktop != null) { inherit desktop; }
        );

        home.file = lib.mkIf config.scripts.${name}.enable (
          builtins.listToAttrs (
            map (linkPath: {
              name = lib.removePrefix "~/" linkPath;
              value = {
                source = "${scriptDrv}/bin/${name}";
              };
            }) extraLinks
          )
        );

        assertions = [
          {
            assertion =
              !config.scripts.${name}.enable
              || !config.scripts.${name}.desktop.enable
              || config.terminal.kitty.enable;
            message = "scripts.${name}.desktop.enable requires terminal.kitty.enable because desktop entries launch scripts in kitty.";
          }
        ];
      };
    };
in
{
  inherit mkScript mkScriptModule;
}

{ lib, pkgs }:
let
  shellArgs = {
    zsh = name: file: "--zsh --name _${name} ${file}";
    bash = name: file: "--bash --name ${name}.bash ${file}";
  };

  mkScript =
    name: path: description: env: deps: completion:
    let
      descLines = lib.filter (s: s != "") (lib.splitString "\n" description);
      descComment =
        if descLines == [ ] then "" else lib.concatMapStringsSep "\n" (line: "# ${line}") descLines + "\n";
      envVars = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (n: v: "export ${n}=${lib.escapeShellArg (toString v)}") env
      );
      base = pkgs.writeShellApplication {
        inherit name;
        runtimeInputs = deps;
        text = ''
          ${descComment}${envVars}
          ${builtins.readFile path}
        '';
      };
      completionDrv =
        pkgs.runCommand "${name}-completion"
          {
            nativeBuildInputs = [ pkgs.installShellFiles ];
          }
          (
            "mkdir -p $out\n"
            + lib.concatStringsSep "\n" (
              lib.mapAttrsToList (shell: content: ''
                installShellCompletion ${shellArgs.${shell} name (pkgs.writeText "_${name}.${shell}" content)}
              '') completion
            )
          );
    in
    if completion == { } then
      base
    else
      pkgs.symlinkJoin {
        name = name;
        paths = [
          base
          completionDrv
        ];
        meta = base.meta or { };
      };
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
      completion ? { },
    }:
    let
      scriptDrv = mkScript name path description env deps completion;
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
        completion = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = completion != { };
            description = "Whether to install completions for the ${name} script.";
          };
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
          {
            assertion = !config.scripts.${name}.completion.enable || completion != { };
            message = "scripts.${name}.completion.enable is true but no completion text was provided to mkScriptModule.";
          }
        ];
      };
    };
in
{
  inherit mkScript mkScriptModule;
}

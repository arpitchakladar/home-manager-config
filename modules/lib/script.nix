# Library for creating script modules
{
  lib,
  pkgs,
}:
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

  mkPythonScript =
    {
      name,
      path,
      description ? "",
      python ? pkgs.python3,
      pythonPackages ? (ps: [ ]),
      deps ? [ ],
      gobjectIntrospection ? false,
    }:
    let
      pythonEnv = python.withPackages pythonPackages;
      pathPrefix = lib.concatStringsSep ":" (
        [ "${pythonEnv}/bin" ] ++ map (p: "${lib.getBin p}/bin") deps
      );
    in
    pkgs.stdenv.mkDerivation {
      pname = name;
      version = "0.1.0";
      src = path;
      dontUnpack = true;
      meta = lib.optionalAttrs (description != "") { inherit description; } // {
        mainProgram = name;
      };

      nativeBuildInputs =
        lib.optionals gobjectIntrospection [
          pkgs.wrapGAppsHook3
          pkgs.gobject-introspection
        ]
        ++ lib.optional (!gobjectIntrospection) pkgs.makeWrapper;
      buildInputs = lib.optionals gobjectIntrospection [ pkgs.gtk3 ];

      installPhase = ''
        mkdir -p $out/bin
        install -m755 $src $out/bin/${name}
        patchShebangs $out/bin/${name}
      '';

      # wrapGAppsHook3 wraps every executable in $out/bin automatically,
      # setting GI_TYPELIB_PATH etc. from buildInputs' closure. With
      # gobjectIntrospection = false a plain wrapProgram only extends PATH.
      preFixup =
        if gobjectIntrospection then
          ''
            gappsWrapperArgs+=(--prefix PATH : "${pathPrefix}")
          ''
        else
          ''
            wrapProgram $out/bin/${name} --prefix PATH : "${pathPrefix}"
          '';
    };

  mkScriptModule =
    {
      scope ? [ ],
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
      scriptAttrs = scope ++ [ name ];
      dottedName = lib.concatStringsSep "." scriptAttrs;
      c = lib.getAttrFromPath scriptAttrs config;
      scriptDrv = mkScript name path description env deps completion;
    in
    {
      options = lib.setAttrByPath scriptAttrs {
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
        completion.enable = lib.mkOption {
          type = lib.types.bool;
          default = completion != { };
          description = "Whether to install completions for the ${name} script.";
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

      config =
        lib.setAttrByPath scriptAttrs (
          lib.mkIf c.enable (
            {
              package = scriptDrv;
            }
            // lib.optionalAttrs (desktop != null) { inherit desktop; }
          )
        )
        // {
          home.file = lib.mkIf c.enable (
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
              assertion = !c.enable || !c.desktop.enable || config.terminal.kitty.enable;
              message = "${dottedName}.desktop.enable requires terminal.kitty.enable because desktop entries launch scripts in kitty.";
            }
            {
              assertion = !c.completion.enable || completion != { };
              message = "${dottedName}.completion.enable is true but no completion text was provided to mkScriptModule.";
            }
          ];
          scriptPaths = [ scriptAttrs ];
        };
    };
in
{
  inherit mkPythonScript mkScript mkScriptModule;
}

# Internal aggregation for script modules registered via mkScriptModule
{
  config,
  lib,
  ...
}:
{
  options.scriptPaths = lib.mkOption {
    type = lib.types.listOf (lib.types.listOf lib.types.str);
    default = [ ];
    internal = true;
    description = "Attr paths of script modules registered via mkScriptModule.";
  };

  config = {
    home.packages = lib.filter (p: p != null) (
      map (path: (lib.getAttrFromPath path config).package) config.scriptPaths
    );

    xdg.desktopEntries = lib.listToAttrs (
      map
        (
          path:
          let
            name = lib.last path;
            sc = lib.getAttrFromPath path config;
          in
          lib.nameValuePair name {
            name = sc.desktop.displayName;
            exec = "${lib.getExe config.terminal.kitty.package} --class ${name} -e ${lib.getExe sc.package}";
            icon = sc.desktop.icon;
            categories = [ "Utility" ];
            terminal = false;
            type = "Application";
          }
        )
        (
          lib.filter (
            path:
            let
              sc = lib.getAttrFromPath path config;
            in
            sc.enable && sc.desktop.enable
          ) config.scriptPaths
        )
    );
  };
}

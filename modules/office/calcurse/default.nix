# Text-based calendar and scheduling application
{
  config,
  lib,
  pkgs,
  ...
}:
let
  calcurseSync = pkgs.writeShellScriptBin "calcurse-sync" (builtins.readFile ./calcurse-sync.sh);

  calcursePackage = pkgs.symlinkJoin {
    name = "calcurse-wrapped";
    paths = [
      pkgs.bash
      pkgs.calcurse
      calcurseSync
    ]
    ++ lib.optionals config.development.nixvim.enable [ config.development.nixvim.package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      ${lib.optionalString config.development.nixvim.enable ''
        wrapProgram $out/bin/calcurse --set PAGER "nvim"
      ''}
      wrapProgram $out/bin/calcurse-sync \
        --prefix PATH : ${
          lib.makeBinPath [
            config.development.git.package
            pkgs.coreutils
            pkgs.gnused
          ]
        }
    '';
    meta = {
      mainProgram = "calcurse";
    };
  };
in
{
  options.office.calcurse = {
    enable = lib.mkEnableOption "Enables calcurse.";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = calcursePackage;
      description = "The calcurse package to use.";
    };
  };
  config = lib.mkIf config.office.calcurse.enable {
    home.packages = [ config.office.calcurse.package ];
    xdg.configFile."calcurse/conf" = {
      source = ./conf;
      force = true;
    };
    xdg.configFile."calcurse/keys" = {
      source = ./keys;
      force = true;
    };
    xdg.configFile."calcurse/hooks/pre-load" = {
      source = ./hooks/pre-load;
      executable = true;
      force = true;
    };
    xdg.configFile."calcurse/hooks/post-save" = {
      source = ./hooks/post-save;
      executable = true;
      force = true;
    };

    programs.git.includes = lib.mkIf config.development.git.enable [
      {
        condition = "gitdir:${config.xdg.dataHome}/calcurse/";
        contents = {
          user = {
            name = "Calcurse of ${config.home.username}";
            email = "${config.home.username}@calcurse.localhost";
          };
          commit = {
            gpgSign = false;
          };
          tag = {
            gpgSign = false;
          };
        };
      }
    ];
  };
}

{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.mymodules.fonts;
  inherit
    (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    ;

  inherit
    (lib.types)
    either
    listOf
    package
    str
    ;

  mkListOfStringOption = def: desc:
    mkOption {
      default = [ def ];
      description = desc;
      type = listOf str;
    };
in
{
  options = {
    mymodules.fonts = {
      enable = mkEnableOption "fonts";
      packages = {
        monospace = mkPackageOption pkgs "source-code-pro" { };
        sansSerif = mkPackageOption pkgs "source-sans" { };
        serif = mkPackageOption pkgs "source-serif" { };
        emoji = mkPackageOption pkgs "twemoji-color-font" { };
	extras = mkOption {
	  type = listOf package;
	  default = [ ];
	};
      };
      names = {
        monospace = mkListOfStringOption "Source Code Pro" "Monospace font";
        sansSerif = mkListOfStringOption "Source Sans 3" "Sans Serif font";
        serif = mkListOfStringOption "Source Serif 4 " "Serif font";
        emoji = mkListOfStringOption "Twemoji" "Emoji font";
      };
    };
  };

  config = mkIf cfg.enable {
    fonts.packages = (builtins.attrValues {
      inherit
        (cfg.packages)
        sansSerif
        monospace
        serif
        emoji
        ;
    }) ++ cfg.packages.extras;

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        inherit
          (cfg.names)
          monospace
          sansSerif
          serif
          emoji
          ;
      };
    };
  };
}

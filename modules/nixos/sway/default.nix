{ config, pkgs, lib, ... }:
let
  cfg = config.mymodules.sway;
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    ;

  inherit (lib.types)
    listOf
    package
    ;
in
{
  options.mymodules.sway = {
    enable = mkEnableOption "sway";
    package = mkPackageOption pkgs "sway" {};
    extraPackages = mkOption {
      type = listOf package;
      default =
        let
          noPackageSet = builtins.attrValues {
            inherit (pkgs)
              mako
              autotiling-rs
              fuzzel
              light
              swaylock-effects
	      pwvucontrol
              ;
          };
          sway-contrib = [
            pkgs.sway-contrib.grimshot
          ];
        in
        (noPackageSet ++ sway-contrib);
    };
  };

  config = mkIf cfg.enable {
    hardware.opengl.enable = true;
    services.libinput.enable = true;
    programs.sway = {
      enable = true;
      inherit (cfg)
        package 
	extraPackages
	;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
    };
    programs.waybar.enable = true;
    systemd.user.tmpfiles.rules =
      let
        inherit (config.users.users.artur) home;
	cfgdir = ./. + "/config";
      in
      [
        "L+ ${home}/.config/sway - - - - ${cfgdir}/sway"
        "L+ ${home}/.config/waybar - - - - ${cfgdir}/waybar"
        "L+ ${home}/.config/mako - - - - ${cfgdir}/mako"
	"L+ ${home}/.config/fuzzel - - - - ${cfgdir}/fuzzel"
      ];
  };
}

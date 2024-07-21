{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    ;
  inherit (lib.types)
    bool
    listOf
    package
    ;
  cfg = config.mymodules.xorg;
in
{
  options.mymodules.xorg = {
    enable = mkEnableOption "Xorg";
    hiDPI = mkOption {
      type = bool;
      default = false;
      description = "HiDPI";
    };
    i3 = {
      enable = mkEnableOption "i3";
      extraPackages = mkOption {
        type = listOf package;
        default = builtins.attrValues {
          inherit (pkgs)
            rofi
            maim
            slop
            xdotool
            polybar
            dunst
            ;
        };
        description = "i3 extra packages";
      };
    };
  };

  config = mkIf cfg.enable {
    hardware.opengl.enable = true;
    services.libinput.enable = true;
    services.xserver = {
      enable = true;
      dpi =
        if cfg.hiDPI
        then 192
        else 96;
      windowManager.i3 =
        mkIf cfg.i3.enable {
          enable = true;
          extraPackages = cfg.i3.extraPackages;
        };
      displayManager.sx.enable = true;
    };

    systemd.user.tmpfiles.rules =
      mkIf cfg.i3.enable [
        "L+ ${config.users.users.artur.home}/.config/i3 - - - - ${./. + "/i3"}"
      ];
  };
}

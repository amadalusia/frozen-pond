{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.mymodules.alacritty;
  inherit
    (lib)
    mkIf
    mkEnableOption
    ;
in
{
  options.mymodules.alacritty = {
    enable = mkEnableOption "alacritty";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.alacritty
    ];

    systemd.user.tmpfiles.rules = [
      "L+ ${config.users.users.artur.home}/.config/alacritty - - - - ${./. + "/config"}"
    ];
  };
}

{ config, pkgs, lib, ... }:
let
  cfg = config.mymodules.pipewire;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.mymodules.pipewire = {
    enable = mkEnableOption "pipewire";
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      audio.enable = true;
      wireplumber.enable = true;
    };

    environment.systemPackages = [
      pkgs.helvum
      pkgs.pwvucontrol
    ];
  };
}

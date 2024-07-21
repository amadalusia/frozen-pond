{ config, pkgs, lib, ... }:
let
  cfg = config.mymodules.chromium;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.mymodules.chromium = {
    enable = mkEnableOption "chromium";
  };
  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      extensions = [
        "bkkmolkhemgaeaeggcmfbghljjjoofoh" # Catppuccin Mocha (cheating!)
      ];
    };

    environment.systemPackages = [
      pkgs.google-chrome
    ];
  };
}

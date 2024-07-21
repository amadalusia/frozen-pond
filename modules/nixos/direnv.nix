{ config, lib, ... }:
let
  cfg = config.mymodules.direnv;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.mymodules.direnv = {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };
}
